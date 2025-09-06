## MCP install and activation guide (project-scoped)

This guide installs and activates the MCP servers defined in `.claude/mcp.json` for this project, and makes them available inside Cursor via `/mcp`.

References: [Anthropic docs: Connect Claude Code to tools via MCP](https://docs.anthropic.com/en/docs/claude-code/mcp)

### Prerequisites
- Node.js 18+ available on your PATH (`node -v`)
- Claude CLI installed (`claude -v`)
- This repository checked out, and your shell in the project root

Optional but recommended:
- Ensure secrets are not committed. Prefer environment variables over inline tokens in JSON.

### 1) Review and secure your MCP config
Your project-defined servers live at:
- `.claude/mcp.json` (source of truth you edit)

Security best practice: replace hard-coded secrets with environment-variable expansion supported by Claude Code.

Example (uses defaults and env expansion) — see Anthropic docs for details:

```json
{
  "mcpServers": {
    "api-server": {
      "type": "sse",
      "url": "${API_BASE_URL:-https://api.example.com}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}"
      }
    }
  }
}
```

Set required env vars before launching Cursor or the installer, e.g. in your shell profile or `.envrc`.

### 2) Install servers from JSON into project scope
We provide an installer that reads `.claude/mcp.json` and configures each server via the CLI.

Command (run from project root):

```bash
node ./scripts/install-mcp-from-json.mjs --replace --scope project --from ./.claude/mcp.json
```

Flags:
- `--from <path>`: JSON file to import (defaults to `./.claude/mcp.json`)
- `--scope project|user|local`: configuration scope (default: `project`)
- `--replace`: if a server already exists with the same name, remove and re-add it

Notes:
- The installer writes project-scoped config (stored as `.mcp.json` at the repo root).
- If you see “A server with the name X already exists”, re-run with `--replace`.

### 3) Approve and activate in Cursor
Inside Cursor (Claude Code):
1. Restart the Claude Code session (or reload the project) so it picks up changes.
2. Run `/mcp` and approve the newly detected servers for this project.
3. For remote servers requiring OAuth, follow the browser flow to authenticate.

Tips from Anthropic docs:
- Authentication tokens are stored securely and refreshed automatically.
- You can “Clear authentication” in the `/mcp` menu to revoke access.

### 4) Verify servers are available
In Cursor:
- Run `/mcp` to see connected servers and any prompts they expose.
- Try an MCP prompt such as `/mcp__github__list_prs` (names vary by server).
- Reference resources using `@server:protocol://path`, e.g. `@github:issue://123`.

From the CLI:
- Project-scoped servers may not appear in a plain `claude mcp list`. Verify individually:

```bash
claude mcp get <server-name>
```

### 5) Troubleshooting
- Already exists: run the installer with `--replace`.
- “No MCP servers configured” in CLI after install: expected if you’re looking at a different scope. Servers installed here are project-scoped and visible inside Cursor’s `/mcp` for this project. Use `claude mcp get <name>` to check an individual server.
- OAuth window didn’t open: copy the URL shown in Cursor into your browser. You can also clear auth in `/mcp` and retry.
- Large output warnings: increase MCP tool output limit (per docs):

```bash
export MAX_MCP_OUTPUT_TOKENS=50000
claude
```

- Reset approvals (force re-approval prompt in this project):

```bash
claude mcp reset-project-choices
```

### 6) Maintaining your MCP setup
- Update servers from JSON:

```bash
node ./scripts/install-mcp-from-json.mjs --replace --scope project --from ./.claude/mcp.json
```

- Remove a server:

```bash
claude mcp remove <server-name>
```

- Move secrets to env vars: replace inline tokens in `.claude/mcp.json` with `${VAR}` and export those vars in your shell or CI environment.

### 7) Team setup
For new developers on the project:
1. Pull the repo
2. Ensure Node and Claude CLI are installed
3. Export any required environment variables
4. Run the installer (step 2)
5. Approve servers in Cursor (step 3)

That’s it — the project’s MCP servers are now ready in Cursor via `/mcp`.


