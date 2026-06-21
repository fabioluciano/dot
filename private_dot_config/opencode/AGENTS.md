# Global Rules

## MCP-FIRST (read this before anything else)

Before ANY code investigation, you MUST try the specialized MCP first —
generic grep/glob/Read are the fallback, never the first move:

1. **Any code question or pre-edit survey** (how/where/what/flow, "find X",
   the symbols you are about to change) → call `codegraph_explore` FIRST.
   If codegraph returns nothing, the repo is not indexed — say so and run/ask
   for `codegraph index`; do NOT silently fall back to grep.
2. **Structural / multi-hop / impact / complexity questions** →
   `codebase-memory` (`search_graph`, `trace_path`, `query_graph`). If the
   project is missing from `list_projects`, index it with `index_repository`
   before answering — do NOT fall back to grep.
3. **External library/framework behavior** → `context7` (`resolve-library-id`
   then `query-docs`) before guessing any API.
4. **Browser task** → `playwright`. **Public-repo examples** → `gh_grep`.
   **GitHub ops** → `github`.

Falling back to grep/glob when a specialized MCP exists (and is indexed) is a
defect. The full per-tool guidance is in "MCP Usage (mandatory)" below.

## Language
- Always respond in Brazilian Portuguese (pt-BR)
- Code comments in English, explanations in Portuguese

## Code Style
- Prefer functional patterns over imperative
- Use TypeScript strict mode when applicable
- Follow existing project conventions over personal preferences

## Workflow
- Always run linter/typecheck after making changes
- Never commit unless explicitly asked
- Prefer editing existing files over creating new ones

## Security
- Never expose secrets, tokens, or API keys in code
- Never commit .env files or credentials
- Use environment variables for sensitive config

## Git
- Never use --force or --hard reset without explicit confirmation
- Prefer squash merges
- Use conventional commit messages (feat:, fix:, chore:, etc.)

## MCP Usage (mandatory)

Use the right specialized tool for each task. NEVER fall back to generic grep/glob when a specialized MCP exists.

### Code Intelligence
- **codegraph**: PRIMARY tool for almost any code question or before an edit — "how does X work", architecture, a bug, "where is X", surveying an area, or the symbols you are about to change. Call `codegraph_explore` FIRST (returns verbatim source grouped by file + the call path among them in one capped call — treat shown source as already Read). Use `codegraph_node` to read a whole file (Read-equivalent, with dependents attached) or one named symbol with its caller/callee trail; `codegraph_callers` for "who calls Y"; `codegraph_search` only for quick name lookups. Prefer these over grep/glob/Read for code discovery.
- **codebase-memory**: Use for graph-level queries — multi-hop relationships, cross-service flow, complexity/bottleneck hot-paths (`query_graph` Cypher), architecture clusters (`get_architecture`), and impact analysis. Call `search_graph` / `trace_path` / `get_code_snippet` for structural questions BEFORE running broad grep or glob searches.

### External Documentation
- **context7**: ALWAYS use for external library/framework docs. Call `resolve-library-id` then `query-docs` BEFORE guessing any API shape or behavior.

### GitHub & Code Examples
- **gh_grep**: Use to find real-world code examples across public GitHub repos.
- **github**: Use for all GitHub operations — PRs, issues, releases, file contents, commits.

### Browser Automation
- **playwright**: MUST use for ANY browser task — navigate, screenshot, scrape, UI testing. NEVER use curl or fetch for pages that require a real browser.

### Reasoning
- **sequential-thinking**: Use for complex multi-step problems that benefit from structured reasoning chains.

### Web Fetch
- **fetch**: Use for simple one-shot URL fetches. Prefer context-mode fetch+index tools when you need to index or derive answers from large docs.

### Memory
- **codebase-memory is the single canonical memory system.** The generic `memory` MCP has been removed. Do NOT reference it.
