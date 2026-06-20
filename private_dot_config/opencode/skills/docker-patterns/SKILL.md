---
name: docker-patterns
description: "Production-grade Docker patterns for Dockerfiles, multi-stage builds, docker compose, container security, layer cache optimization, image size minimization, healthchecks, .dockerignore, and non-root users. Use when writing, reviewing, or optimizing any Dockerfile, docker-compose.yml, or container image. Triggers: 'Dockerfile', 'multi-stage build', 'docker compose', 'container', 'layer cache', 'image size', 'healthcheck', '.dockerignore', 'non-root user', 'distroless', 'alpine', 'docker security', 'docker best practices', 'docker patterns'."
---

# Docker Patterns — Production-Grade Container Recipes

Reference guide for writing, reviewing, and optimizing Dockerfiles and docker-compose configurations.

## Multi-Stage Builds

Separate build dependencies from runtime. The final image should contain only what the application needs to run.

```dockerfile
# Stage 1: build
FROM node:22-slim AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts
COPY . .
RUN npm run build

# Stage 2: runtime — no devDependencies, no source, no build tools
FROM node:22-slim AS runtime
WORKDIR /app
RUN groupadd -r app && useradd -r -g app -d /app -s /sbin/nologin app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
USER app
CMD ["node", "dist/index.js"]
```

**Why this matters:**
- Build tools (compilers, bundlers, native headers) never ship in the final image.
- Smaller attack surface, faster pulls, fewer CVEs to patch.

### Language-Specific Multi-Stage Patterns

**Go (static binary, scratch/distroless final):**
```dockerfile
FROM golang:1.22 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /server ./cmd/server

FROM gcr.io/distroless/static-debian12
COPY --from=builder /server /server
ENTRYPOINT ["/server"]
```

**Python (pip in builder, venv copied to runtime):**
```dockerfile
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.12-slim AS runtime
COPY --from=builder /install /usr/local
COPY . .
CMD ["python", "main.py"]
```

## Layer Cache Optimization

Docker caches layers in order. A changed layer invalidates all subsequent layers. Place instructions from **least frequently changed** to **most frequently changed**.

```dockerfile
# 1. Base image (changes rarely)
FROM node:22-slim

# 2. OS-level deps (changes rarely)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. Dependency lockfiles (changes occasionally)
COPY package.json package-lock.json ./
RUN npm ci --ignore-scripts

# 4. Application source (changes frequently)
COPY . .
```

**Key rules:**
- Copy lockfiles (`package.json`, `go.sum`, `requirements.txt`, `Cargo.lock`) **before** copying source.
- Never `COPY . .` before `RUN npm ci` — every source change busts the dependency cache.
- Use `--mount=type=cache` for package manager caches when BuildKit is available:
  ```dockerfile
  RUN --mount=type=cache,target=/root/.npm npm ci
  ```

## Non-Root User

Never run containers as root in production. The `USER` directive is cheap and prevents container breakouts from granting host root.

```dockerfile
# Create user early (layers rarely change)
RUN groupadd -r app && useradd -r -g app -d /app -s /sbin/nologin app

# Set ownership of runtime directories
RUN chown -R app:app /app

USER app
```

**Distroless alternative** — use the `nonroot` tag:
```dockerfile
FROM gcr.io/distroless/static-debian12:nonroot
```

## Healthcheck Patterns

A healthcheck tells the orchestrator (Docker, Compose, Swarm, K8s livenessProbe) whether the container is actually serving traffic.

```dockerfile
# HTTP endpoint
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# TCP socket
HEALTHCHECK --interval=30s --timeout=3s \
  CMD nc -z localhost 5432 || exit 1

# Process check (weaker — prefer endpoint)
HEALTHCHECK --interval=30s \
  CMD pgrep -x myapp || exit 1
```

**In docker-compose.yml (preferred for orchestration):**
```yaml
services:
  api:
    image: myapp:latest
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 5s
      retries: 3
      start_period: 10s
```

### depends_on with Condition

```yaml
services:
  db:
    image: postgres:16
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      retries: 5

  api:
    depends_on:
      db:
        condition: service_healthy
```

Without `condition: service_healthy`, `depends_on` only waits for the container to *start*, not to be *ready*.

## .dockerignore Essentials

Every `docker build` context scan sends files to the daemon. A `.dockerignore` reduces context size and prevents secrets from entering layers.

```
# Version control
.git
.gitignore

# Dependencies (rebuild in container)
node_modules
vendor
__pycache__
.venv

# Build artifacts
dist
build
*.egg-info

# IDE and OS
.vscode
.idea
.DS_Store

# Docker and CI
Dockerfile*
docker-compose*.yml
.dockerignore
.docker/

# Secrets — NEVER bake into images
.env
.env.*
*.pem
*.key
*.p12
secrets/

# Tests and docs (not needed at runtime)
tests/
test/
docs/
*.md
```

## Image Size Minimization

Every MB in the image costs pull time, storage, and increases the CVE attack surface.

| Strategy | Impact | Tradeoff |
|---|---|---|
| Alpine base (`-alpine`) | ~50MB smaller | musl libc incompatibility with some native libs |
| Distroless | ~20-80MB, no shell | Harder to debug (use debug variants for dev) |
| `--no-install-recommends` | Prevents suggested packages | Some packages may lack expected extras |
| `rm -rf /var/lib/apt/lists/*` | Removes apt cache in same layer | Must be in same `RUN` as `apt-get install` |
| Multi-stage | Drops build deps entirely | More complex Dockerfile |
| `npm ci --omit=dev` | Excludes devDependencies | No build/test tools in image |

**Combining apt-get cleanup in a single layer:**
```dockerfile
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
    && rm -rf /var/lib/apt/lists/*
```

The `update`, `install`, and `rm` must be in the **same `RUN`** — otherwise the apt cache is cached in a separate layer and never removed.

## Security Patterns

### No Secrets in Image Layers

Every `RUN`, `COPY`, and `ADD` creates an immutable layer. Secrets copied or echoed in any layer persist even if deleted in a later layer.

**Wrong:**
```dockerfile
COPY .npmrc .npmrc    # ← .npmrc with auth token is now in layer history
RUN npm ci
RUN rm .npmrc         # ← too late, layer already exists
```

**Right — use BuildKit secrets:**
```dockerfile
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc npm ci
```

Build with: `docker build --secret id=npmrc,src=$HOME/.npmrc .`

### Pin Base Image Digests

Tags like `node:22` are mutable — the upstream can push a different image under the same tag. For reproducible and auditable builds:

```dockerfile
FROM node:22-slim@sha256:abc123def456...
```

Use `docker inspect --format='{{index .RepoDigests 0}}' node:22-slim` to get the current digest.

### Drop Capabilities at Runtime

```bash
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE myapp
```

```yaml
# docker-compose.yml
services:
  api:
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
    read_only: true
    tmpfs:
      - /tmp
    security_opt:
      - no-new-privileges:true
```

## Docker Compose Patterns

### Full Production-Like Stack

```yaml
services:
  app:
    build:
      context: .
      target: runtime   # multi-stage target
    ports:
      - "8080:8080"
    environment:
      - DATABASE_URL=postgresql://postgres:secret@db:5432/mydb
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: "1.0"
          memory: 512M

  db:
    image: postgres:16
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: secret
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      retries: 5

volumes:
  pgdata:   # named volume survives `docker compose down`
```

**Key points:**
- Named volumes (`pgdata`) persist data across container restarts. Anonymous volumes are harder to manage.
- `restart: unless-stopped` avoids restart loops on config errors (unlike `always`).
- Resource limits prevent a single container from starving the host.

### Environment Variables: Files vs Inline

```yaml
services:
  app:
    env_file:
      - .env.production   # one KEY=VALUE per line
    environment:
      - NODE_ENV=production   # overrides env_file if duplicate
```

Never commit `.env` files with real secrets. Use `.env.example` with placeholder values as documentation.
