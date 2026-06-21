# Global Rules

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
- **codebase-memory**: ALWAYS use for any code question — "where is X", "who calls Y", "what does Z do", data flow, impact analysis, code snippets. Call `search_graph` / `trace_path` / `get_code_snippet` BEFORE running broad grep or glob searches.

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
