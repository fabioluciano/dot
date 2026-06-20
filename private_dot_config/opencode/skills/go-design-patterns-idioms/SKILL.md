---
name: go-design-patterns-idioms
description: "Idiomatic Go design patterns and best-practice idioms. Use when writing or reviewing Go code that needs interfaces, error handling, concurrency, context propagation, functional options, struct embedding, or defer patterns. Triggers: 'Go', 'golang', 'interface', 'error wrapping', 'goroutine', 'context', 'functional options', 'worker pool', 'channel', 'defer', 'zero value', 'embedding', 'sentinel error', 'errgroup', 'Go idiom', 'Go pattern'."
---

# Go Design Patterns & Idioms

Use this skill when writing or reviewing Go code to ensure idiomatic, production-quality patterns.

---

## 1. Small Interfaces

Go favors small, focused interfaces. Accept interfaces, return structs.

```go
// Good: consumer defines what it needs.
type UserStore interface {
    GetByID(ctx context.Context, id string) (*User, error)
}

// Bad: bloated interface that forces unnecessary coupling.
type UserStore interface {
    GetByID(ctx context.Context, id string) (*User, error)
    GetByEmail(ctx context.Context, email string) (*User, error)
    List(ctx context.Context, limit int) ([]*User, error)
    Create(ctx context.Context, u *User) error
    Update(ctx context.Context, u *User) error
    Delete(ctx context.Context, id string) error
}
```

The `io.Reader` / `io.Writer` philosophy: one method interfaces compose naturally.

```go
// Accept the narrowest interface possible.
func Process(r io.Reader) error { /* ... */ }

// Return concrete types — callers get all methods, not a subset.
func NewService(dsn string) (*Service, error) { /* ... */ }
```

---

## 2. Error Handling

### Wrap errors with `%w` and sentinel errors

```go
var ErrNotFound = errors.New("not found")

func GetUser(ctx context.Context, id string) (*User, error) {
    u, err := store.GetByID(ctx, id)
    if err != nil {
        // %w wraps the error — callers can use errors.Is / errors.As.
        return nil, fmt.Errorf("get user %s: %w", id, err)
    }
    return u, nil
}
```

### Check errors with `errors.Is` / `errors.As`

```go
u, err := GetUser(ctx, "123")
if errors.Is(err, ErrNotFound) {
    // handle not-found
}

var domainErr *DomainError
if errors.As(err, &domainErr) {
    // access domainErr.Code, domainErr.Message
}
```

### Custom error types

```go
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation: %s %s", e.Field, e.Message)
}
```

### Never ignore errors silently

```go
// Bad.
_ = doSomethingImportant()

// If intentionally ignoring, document why.
_ = doSideEffect() // side-effect only, error not actionable.
```

---

## 3. Functional Options

Use variadic `Option` functions for optional configuration. Keeps constructors clean.

```go
type Server struct {
    host    string
    port    int
    timeout time.Duration
}

type Option func(*Server)

func WithPort(port int) Option {
    return func(s *Server) { s.port = port }
}

func WithTimeout(d time.Duration) Option {
    return func(s *Server) { s.timeout = d }
}

func NewServer(host string, opts ...Option) *Server {
    s := &Server{
        host:    host,
        port:    8080,            // sensible default
        timeout: 30 * time.Second, // sensible default
    }
    for _, opt := range opts {
        opt(s)
    }
    return s
}

// Usage.
srv := NewServer("localhost", WithPort(9090), WithTimeout(5*time.Second))
```

---

## 4. Context Propagation

`context.Context` is always the first parameter.

```go
// Good: context flows through the call chain.
func (s *Service) GetUser(ctx context.Context, id string) (*User, error) {
    return s.repo.GetByID(ctx, id)
}

// Use context for cancellation and deadlines.
ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
defer cancel()

resp, err := http.NewRequestWithContext(ctx, "GET", url, nil)
```

### Pass context, never store it

```go
// Bad: context stored in struct.
type Service struct {
    ctx context.Context // NEVER
}

// Good: context passed per-call.
func (s *Service) DoWork(ctx context.Context) error { /* ... */ }
```

---

## 5. Concurrency Idioms

### Worker pool

```go
func WorkerPool(ctx context.Context, jobs <-chan Job, numWorkers int) <-chan Result {
    results := make(chan Result, numWorkers)
    var wg sync.WaitGroup

    for i := 0; i < numWorkers; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            for job := range jobs {
                select {
                case <-ctx.Done():
                    return
                case results <- process(job):
                }
            }
        }()
    }

    // Close results when all workers finish.
    go func() {
        wg.Wait()
        close(results)
    }()

    return results
}
```

### Channel ownership: the sender closes

```go
// Producer owns the channel — it creates, writes, and closes it.
func produce(ctx context.Context) <-chan int {
    ch := make(chan int)
    go func() {
        defer close(ch) // sender closes, never the receiver.
        for i := 0; ; i++ {
            select {
            case <-ctx.Done():
                return
            case ch <- i:
            }
        }
    }()
    return ch
}
```

### `errgroup` for parallel tasks

```go
g, ctx := errgroup.WithContext(ctx)

g.Go(func() error {
    return fetchUser(ctx, id)
})
g.Go(func() error {
    return fetchOrders(ctx, id)
})

if err := g.Wait(); err != nil {
    return fmt.Errorf("parallel fetch: %w", err)
}
```

### `select` with `default` for non-blocking

```go
select {
case msg := <-ch:
    handle(msg)
default:
    // no message available, don't block
}
```

---

## 6. Struct Embedding vs Composition

Embedding promotes methods, not fields for API contracts.

```go
type Logger struct {
    *log.Logger // promoted: caller can use Logger.Printf directly
}

type Service struct {
    logger  *Logger      // composition: explicit dependency
    store   UserStore    // interface, not concrete type
    mu      sync.RWMutex // embedding for method promotion
}
```

Prefer explicit composition over embedding when it clarifies intent.

```go
// Embedding when you want to "extend" behavior.
type SafeCounter struct {
    mu sync.Mutex
    Counter
}

// Composition when you want to "use" a dependency.
type UserService struct {
    store  UserStore
    mailer Mailer
}
```

---

## 7. Zero Values Useful

Design types so the zero value is valid without a constructor.

```go
// sync.Mutex zero value is unlocked — no NewMutex() needed.
var mu sync.Mutex
mu.Lock()

// bytes.Buffer zero value is an empty buffer.
var buf bytes.Buffer
buf.WriteString("hello")

// Your own types should follow this principle.
type Config struct {
    Timeout time.Duration // zero = no timeout (caller decides)
    MaxRetries int        // zero = no retries (safe default)
}
```

If zero value is not useful, provide a `New` constructor and document why.

```go
// Pool requires non-nil map — zero value would panic on use.
type Pool struct {
    items map[string]*Item
}

func NewPool() *Pool {
    return &Pool{items: make(map[string]*Item)}
}
```

---

## 8. Defer for Cleanup

Always defer cleanup immediately after acquiring a resource.

```go
f, err := os.Open(path)
if err != nil {
    return fmt.Errorf("open %s: %w", path, err)
}
defer f.Close()

// For functions that return errors on close, capture the error.
func writeToFile(path string) (err error) {
    f, err := os.Create(path)
    if err != nil {
        return err
    }
    defer func() {
        if closeErr := f.Close(); closeErr != nil && err == nil {
            err = closeErr
        }
    }()
    _, err = f.Write(data)
    return err
}
```

---

## Quick Reference

| Pattern | When to use |
|---|---|
| Small interfaces | Decoupling packages, enabling mocks |
| `%w` wrapping | Preserving error chain for `Is`/`As` checks |
| Functional options | Constructors with many optional params |
| `context.Context` first | Any function that does I/O, RPC, or can be cancelled |
| Channel ownership | Goroutine that creates a channel closes it |
| `errgroup` | Parallel tasks with shared cancellation |
| Zero values useful | Types used as struct fields (avoid forced constructors) |
| `defer` cleanup | Every `Open`, `Lock`, `New*` that returns a closer |
