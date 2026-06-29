# Global Rules

## Question Tool (MANDATORY)

Whenever you face a decision that belongs to the user — trade-offs, approach choices, conflicting options, or irreversible actions — you **MUST** use the `question` tool instead of deciding on your own.

Use `question` when:
- There are multiple valid approaches and the choice has meaningful consequences
- A trade-off exists (e.g. speed vs. correctness, simplicity vs. flexibility)
- An action is destructive or hard to reverse
- The user's preference is genuinely unknown and cannot be inferred from context

Do **not** use `question` for decisions that are clearly yours to make (code style within established conventions, trivial implementation details, tool selection with an obvious best fit).

The `question` tool opens an interactive UI. Each call must include a clear question and concrete options for the user to choose from or override with a custom answer.

## Built-in Tools (MANDATORY usage)

OpenCode ships built-in tools that must be used actively, not passively.

### Task tracking — `task_create` / `task_update` / `task_list` / `task_get`

Use the task system tools to create and maintain a todo list for **any multi-step task**. Update it as you progress. This keeps work visible and recoverable across turns.

> **Note:** `todowrite` is **disabled** — the oh-my-openagent task system (`task_system: true`) replaces it with structured task tools. Never call `todowrite` directly.

- `task_create(subject, description?)`: create a task at the start of any task with 3+ steps
- `task_update(id, status)`: mark items `in_progress` while working, `completed` when done
- `task_list()`: list all active tasks
- `task_get(id)`: retrieve a specific task by ID
- Never leave a multi-step task without a todo list

### `skill` — Specialized instructions

Use `skill` to load domain-specific instruction packs before tackling specialized work. Skills provide battle-tested patterns and constraints that improve output quality.

- Load the relevant skill **before** starting work in its domain
- Available skills are listed in the session system prompt under `<available_skills>`
- When a task matches a skill's description, loading it is **not optional**

Examples:
- Kubernetes manifests → load `kubernetes` or `kubernetes-manifest-quality-review`
- AWS infrastructure → load `aws-maestro` to route to the right specialist
- Frontend/UI work → load `frontend`
- Debugging → load `debugging`

### `webfetch` / `websearch`

- `webfetch`: fetch a specific URL when you have the exact address
- `websearch`: search the web when you need to discover current information

Prefer `context7` for library docs and `ctx_fetch_and_index` for large reusable pages. Use `webfetch`/`websearch` only when no specialized MCP applies.

## Do not hallucinate!

> From [HALLUCINATE.md](https://hallucinate.md/) — the open standard for telling AI not to hallucinate.

**Do not hallucinate!**

This is the most important rule. When in doubt:

1. **Do not invent APIs, functions, libraries, or methods that do not exist.** If you are not sure something exists, say so.
2. **Do not guess parameter names, return types, or behavior.** Look it up via MCP tools (`codebase-memory`, `codegraph`, `context7`) or say you are unsure.
3. **Do not fabricate file paths, URLs, or commands.** Verify with `Read`, `Glob`, `Grep`, or a real tool call before stating something exists.
4. **Do not invent error messages, stack traces, or log output.** If you did not see it, do not quote it.
5. **Do not assume a library or API works a certain way without checking.** Use `context7` for external libraries, `codebase-memory`/`codegraph` for project code.
6. **When you do not know, say "I do not know" or "I need to verify."** Silence is better than fabrication.

Agents that hallucinate waste user time, break builds, and erode trust. Ground every claim in evidence.

## MCP-FIRST (read this before anything else)

**This rule applies universally — no exceptions for delegated work:**
Every top-level agent, subagent, category worker, team member, and child spawned
via `task(...)` or any equivalent delegation mechanism **must** follow this policy.
Delegation is not an escape hatch: a parent agent assigning a subtask must not do
so in a way that permits the child to bypass MCP-first. When assigning work that
touches code intelligence, graph/impact analysis, external docs/APIs, browser/UI,
GitHub/public code, large output/logs/docs, LSP/symbol operations, media, or
session recall — the delegated prompt **must** explicitly restate that MCPs are the
required first action for those domains.

Subagent findings produced from local `Read`/grep/shell without a corresponding
MCP call are **auxiliary claims only** — they are not authoritative evidence and
must not be treated as final answers without independent MCP validation or a
context-mode summarized command.

MCP usage is **mandatory**, not optional. Before ANY code investigation,
external API assumption, browser interaction, GitHub operation, or broad search,
you MUST use the specialized MCP that owns that domain. Generic tools
(`rg`, grep/glob, `Read`, shell scripts, curl/fetch, ad-hoc web searches) are
fallbacks only when the required MCP is unavailable or explicitly cannot answer
the task. If the MCP requires an index and the relevant code is not indexed,
index it first; do not use missing indexes as permission to bypass the MCP.

Mandatory routing rules:

1. **Any code question or pre-edit survey** (how/where/what/flow, "find X",
   impact of changing a symbol, or the symbols you are about to edit) → use
   `codebase-memory` or `codegraph` (when available) FIRST. If source code is not indexed,
   run or ask for the indexing step before answering. If the MCP says docs/configs are
   not indexed because they are not source-code symbols, then read those files
   directly; otherwise do NOT silently fall back to grep.
2. **Structural / multi-hop / impact / complexity questions** → use
   `codebase-memory` (`codebase-memory_search_graph`, `codebase-memory_trace_path`, `codebase-memory_query_graph`,
   `codebase-memory_get_architecture`). If the project is missing from `codebase-memory_list_projects`, index it
   with `codebase-memory_index_repository` before answering. If the index exists but is stale,
   refresh it before relying on graph results.
3. **External library/framework/API behavior** → use `context7`:
   `context7_resolve-library-id` first, then `context7_query-docs`, before guessing any API shape,
   option name, lifecycle, or migration behavior.
4. **Browser, UI runtime, scraping, screenshots, or E2E interaction** → use
   `playwright`; do not replace it with curl/fetch for pages that need a browser.
5. **Public GitHub code examples** → use `gh_grep`. **GitHub repository
   operations** (PRs, issues, commits, files, releases, reviews) → use `github`.
6. **Large-output research, logs, generated command output, or reusable docs** →
   use context-mode MCPs (`ctx_batch_execute`, `ctx_execute`, `ctx_search`,
   `ctx_fetch_and_index`) so raw bytes stay out of the conversation context.

Treat bypassing an applicable MCP as a workflow defect. If you cannot use the
required MCP, say why, then use the narrowest fallback.

Indexing rule: when a tool depends on indexed content, missing or stale indexes
must be fixed at the owning MCP layer first (`codegraph` index for codegraph,
`codebase-memory_index_repository` for codebase-memory, `ctx_index` /
`ctx_fetch_and_index` for context-mode). Only use direct reads/searches for file
types the MCP explicitly does not index or after the indexing attempt fails.

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

Use the right specialized MCP for each task. MCP calls are part of the required
workflow and must happen before generic tools when the MCP domain matches.

### Code Intelligence: `codegraph`

Use first for almost every codebase question or before editing code/config that
has symbols or dependencies.

Available functions:
- `codegraph_codegraph_explore`: primary entry point; finds relevant files/symbols and
  returns source plus call paths.
- `codegraph_codegraph_node`: reads a whole indexed file or one symbol with callers and
  callees.
- `codegraph_codegraph_callers`: lists functions that call a symbol.
- `codegraph_codegraph_search`: quick symbol-name lookup when you only need locations.

Examples:
- "Where is provider switching implemented?" → `codegraph_codegraph_explore`.
- "Before editing `oc-provider`, show callers/dependencies" →
  `codegraph_codegraph_explore` or `codegraph_codegraph_node`.
- "Who calls `loadConfig`?" → `codegraph_codegraph_callers`.
- "Find the `AuthService` symbol" → `codegraph_codegraph_search`.

If codegraph reports that source code is not indexed, index it before answering
or ask the user to approve/run the indexing command if required. If codegraph
reports that docs/configs are not indexed because they are outside its source
symbol index, use direct file reads for those files. Do not skip codegraph for
source-code areas.

### Code Graph Memory: `codebase-memory`

<!-- codebase-memory-mcp:start -->
# Codebase Knowledge Graph (codebase-memory-mcp)
 
This project uses codebase-memory-mcp to maintain a knowledge graph of the codebase.
ALWAYS prefer MCP graph tools over grep/glob/file-search for code discovery.
 
## Priority Order
1. `codebase-memory_search_graph` — find functions, classes, routes, variables by pattern
2. `codebase-memory_trace_path` — trace who calls a function or what it calls
3. `codebase-memory_get_code_snippet` — read specific function/class source code
4. `codebase-memory_query_graph` — run Cypher queries for complex patterns
5. `codebase-memory_get_architecture` — high-level project summary
 
## When to fall back to grep/glob
- Searching for string literals, error messages, config values
- Searching non-code files (Dockerfiles, shell scripts, configs)
- When MCP tools return insufficient results
 
## Examples
- Find a handler: `codebase-memory_search_graph(name_pattern=".*OrderHandler.*")`
- Who calls it: `codebase-memory_trace_path(function_name="OrderHandler", direction="inbound")`
- Read source: `codebase-memory_get_code_snippet(qualified_name="pkg/orders.OrderHandler")`
<!-- codebase-memory-mcp:end -->

Use for graph-level questions that need relationships, architecture seams,
multi-hop flows, impact analysis, or complexity signals.

Available functions:
- `codebase-memory_list_projects`, `codebase-memory_index_repository`, `codebase-memory_index_status`: discover/index projects.
- `codebase-memory_search_graph`: find functions/classes/routes/variables in the graph.
- `codebase-memory_search_code`: graph-augmented code search with BM25 ranking.
- `codebase-memory_trace_path`: trace callers/callees, data flow, or cross-service flow.
- `codebase-memory_query_graph`: run Cypher for complex graph and complexity queries.
- `codebase-memory_get_code_snippet`: read a symbol after finding its qualified name.
- `codebase-memory_get_architecture`: summarize packages, services, dependencies, clusters.
- `codebase-memory_detect_changes`: detect code changes and impact since a ref/date.
- `codebase-memory_get_graph_schema`: inspect graph labels and relationships.
- `codebase-memory_manage_adr`: create or update Architecture Decision Records.
- `codebase-memory_ingest_traces`: ingest runtime traces into the graph.
- `codebase-memory_delete_project`: delete a project from the index.

Examples:
- "What breaks if we change this parser?" → `codebase-memory_trace_path` inbound/outbound.
- "Show cross-service flow from this route" → `codebase-memory_trace_path` in cross-service
  mode.
- "Find hot paths with nested loops" → `codebase-memory_query_graph` on complexity fields.
- "Give me the architecture seams" → `codebase-memory_get_architecture`.

If the project is absent from `codebase-memory_list_projects` or the index is stale, run
`codebase-memory_index_repository` before answering graph-level questions.

`codebase-memory` is the canonical memory system. Do not reference or use a
generic `memory` MCP.

### External Documentation: `context7`

Use before making claims about external libraries, frameworks, SDKs, CLIs, or
APIs.

Available functions:
- `context7_resolve-library-id`: map a library name to the exact Context7 library ID.
- `context7_query-docs`: query current docs/examples for that library ID.

Examples:
- "How does Zod v4 define transforms?" → resolve `Zod`, then `context7_query-docs`.
- "What is the current Next.js metadata API?" → resolve `Next.js`, then
  `context7_query-docs`.
- "Which option does Playwright use for traces?" → resolve `Playwright`, then
  `context7_query-docs`.

### GitHub And Public Code: `github` and `gh_grep`

Use `github` for repository operations and `gh_grep` for real-world public code
examples.

`github` available function groups:
- Repository/file operations: `github_get_file_contents`, `github_create_or_update_file`,
  `github_push_files`, `github_delete_file`, `github_create_branch`, `github_fork_repository`.
- Issues: `github_list_issues`, `github_issue_read`, `github_issue_write`, `github_add_issue_comment`,
  `github_sub_issue_write`.
- Pull requests/reviews: `github_list_pull_requests`, `github_pull_request_read`,
  `github_create_pull_request`, `github_update_pull_request`, `github_merge_pull_request`,
  `github_pull_request_review_write`, `github_add_comment_to_pending_review`,
  `github_add_reply_to_pull_request_comment`, `github_request_copilot_review`.
- Commits/releases/tags: `github_list_commits`, `github_get_commit`, `github_search_commits`,
  `github_list_releases`, `github_get_latest_release`, `github_get_release_by_tag`, `github_list_tags`,
  `github_get_tag`.
- Search/discovery: `github_search_code`, `github_search_issues`, `github_search_pull_requests`,
  `github_search_repositories`, `github_search_users`.
- Metadata/security/Copilot: `github_get_me`, `github_list_branches`, `github_get_label`,
  `github_list_repository_collaborators`, `github_get_teams`, `github_get_team_members`,
  `github_list_issue_fields`, `github_list_issue_types`, `github_run_secret_scanning`,
  `github_assign_copilot_to_issue`, `github_create_pull_request_with_copilot`,
  `github_get_copilot_job_status`.

`gh_grep` available function:
- `gh_grep_searchGitHub`: grep-like search for literal code patterns across public
  GitHub repositories.

Examples:
- "Open a PR" → `github_create_pull_request` after inspecting state.
- "Comment on issue #12" → `github_add_issue_comment`.
- "Find public examples of `getServerSession(`" → `gh_grep_searchGitHub`.
- "What changed in this PR?" → `github_pull_request_read` with files/diff.

### Browser Automation: `playwright`

Use for any browser task: navigation, UI verification, screenshots, scraping,
console/network inspection, and browser-based tests.

Available functions:
- Page/session: `playwright_browser_navigate`, `playwright_browser_tabs`, `playwright_browser_close`,
  `playwright_browser_resize`, `playwright_browser_wait_for`.
- Inspection: `playwright_browser_snapshot`, `playwright_browser_take_screenshot`,
  `playwright_browser_console_messages`, `playwright_browser_network_requests`,
  `playwright_browser_network_request`.
- Interaction: `playwright_browser_click`, `playwright_browser_type`, `playwright_browser_fill_form`,
  `playwright_browser_select_option`, `playwright_browser_press_key`, `playwright_browser_hover`,
  `playwright_browser_drag`, `playwright_browser_drop`, `playwright_browser_file_upload`,
  `playwright_browser_handle_dialog`.
- Advanced: `playwright_browser_evaluate`, `playwright_browser_run_code_unsafe`,
  `playwright_browser_navigate_back`.

Examples:
- "Verify the page visually" → `playwright_browser_navigate`, `playwright_browser_snapshot`,
  `playwright_browser_take_screenshot`.
- "Why does login fail?" → inspect form with `playwright_browser_snapshot`, interact, then
  check `playwright_browser_console_messages` and `playwright_browser_network_requests`.
- "Scrape this interactive page" → use Playwright, not curl.

### Context Management And Large Output: `context-mode`

Use when command output, logs, generated files, docs, or web pages are large
enough that raw bytes should not enter the conversation.

Available functions:
- `ctx_batch_execute`: run multiple commands, index outputs, and query relevant
  sections in one call.
- `ctx_execute`: run code/commands in a sandbox and print only derived answers.
- `ctx_execute_file`: analyze one file through code without reading all bytes
  into context.
- `ctx_fetch_and_index`: fetch and index web pages for later search.
- `ctx_index`: persist provided content/path into the searchable store.
- `ctx_search`: search indexed docs, command outputs, and session memory.
- `ctx_stats`, `ctx_doctor`, `ctx_upgrade`, `ctx_purge`, `ctx_insight`: manage
  and inspect context-mode.

Examples:
- "Summarize failures in a 10k-line test log" → `ctx_execute_file`.
- "Run git log, diff, and blame then extract root cause" →
  `ctx_batch_execute` with queries.
- "Fetch these docs and reuse them later" → `ctx_fetch_and_index`, then
  `ctx_search`.

If you need to search reusable local docs or generated artifacts that are not
already in context-mode, index them with `ctx_index` first instead of reading the
entire raw content into the conversation.

### Reasoning: `sequential-thinking`

Use for complex multi-step analysis where explicit decomposition reduces risk.

Available function:
- `sequential-thinking_sequentialthinking`: iterative structured reasoning with revision/branching
  support.

Examples:
- "Choose between three migration strategies" → `sequential-thinking_sequentialthinking`.
- "Analyze a subtle distributed-systems failure" → `sequential-thinking_sequentialthinking`.

### Language Server: `lsp`

Use for symbol-aware editor operations and post-edit validation when a language
server exists for the file type.

Available functions:
- `lsp_diagnostics`: get errors, warnings, hints for a file or directory.
- `lsp_symbols`: list document symbols or search workspace symbols.
- `lsp_goto_definition`: jump from a symbol use to its definition.
- `lsp_find_references`: find references across the workspace.
- `lsp_prepare_rename`: check whether a symbol can be renamed.
- `lsp_rename`: rename a symbol across the workspace.
- `lsp_status`: list configured and active LSP servers.
- `lsp_install_decision`: record whether installing a missing server is allowed
  or declined.

Examples:
- "After editing TypeScript" → run `lsp_diagnostics` on changed files.
- "Rename this function safely" → `lsp_prepare_rename`, then `lsp_rename`.
- "Find every reference to this method" → `lsp_find_references`.

### Media And Documents: `look_at`

Use for quick extraction from images, PDFs, screenshots, and diagrams when a
high-level interpretation is enough.

Available function:
- `look_at`: extract basic information from one or more media files or image
  payloads.

Examples:
- "Summarize this PDF invoice" → `look_at`.
- "What does this architecture diagram show?" → `look_at`.

Do not use `look_at` for pixel-perfect visual QA, exact text fidelity, or UI
interaction; use Playwright or direct file reads where appropriate.

### Session Recall: `session`

Use to inspect previous OpenCode sessions when the user asks to continue,
recover prior context, or search past work.

Available functions:
- `session_list`: list sessions with filters.
- `session_info`: inspect metadata for one session.
- `session_read`: read messages, todos, or transcripts from a session.
- `session_search`: search messages across sessions.

Examples:
- "Continue the work from yesterday" → `session_list`, then `session_read`.
- "Find where we discussed the MCP policy" → `session_search`.

### Agent Orchestration: `skill`, `task`, `team`

Use for specialized workflows, delegation, and user decisions. These are not a
substitute for code intelligence MCPs; use them to route and supervise work.

Available functions:
- `skill`: load a skill or slash-command instruction pack.
- `task_create`, `task_get`, `task_list`, `task_update`: track local work items.
- `team_create`, `team_status`, `team_send_message`, `team_task_create`,
  `team_task_list`, `team_task_update`, `team_shutdown_request`,
  `team_approve_shutdown`, `team_reject_shutdown`, `team_delete`,
  `team_list`, `team_task_get`: coordinate multi-agent team runs when team
  mode is enabled.

Examples:
- "Review this Kubernetes manifest" → load the Kubernetes review skill, then
  delegate or answer with that guidance.
- "Implement this multi-file feature" → create tracked tasks, consult plan if
  needed, then delegate implementation.

### Web Fetch: `fetch` / `webfetch` / `websearch`

Use only when a more specialized MCP does not apply.

Available functions:
- `fetch_fetch`: simple one-shot URL fetch with optional raw HTML.
- `webfetch`: fetch URL content as markdown/text/html.
- `websearch_web_search_exa`: search the web for current public information.

Examples:
- "Fetch this plain text changelog URL" → `fetch_fetch` or `webfetch`.
- "Find current public pages about a topic" → `websearch_web_search_exa`.
- For library docs, prefer `context7`; for large reusable pages, prefer
  `ctx_fetch_and_index`.
