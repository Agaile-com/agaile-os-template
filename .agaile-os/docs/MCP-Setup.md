# Model Context Protocol (MCP) Setup Guide

This guide helps you configure MCP servers to enhance your development workflow with Agaile-OS. MCP enables Claude to interact with external tools and services directly.

## What is MCP?

Model Context Protocol (MCP) is an open standard for connecting AI assistants to data sources and tools. It enables Claude to access your databases, filesystems, APIs, and development tools.

📖 **Learn more**: [Claude Code MCP Documentation](https://docs.anthropic.com/en/docs/claude-code/mcp)

## Quick Setup

1. **Copy the MCP template**:
   ```bash
   cp .agaile-os/templates/mcp.json ~/.claude/mcp.json
   ```

2. **Configure your environment variables** (see below)

3. **Restart Claude Code** to load the new configuration

## Environment Variables Setup

Create a `.env` file in your project root or set these in your system:

```bash
# Required for Supabase MCP server
SUPABASE_ACCESS_TOKEN=your_supabase_access_token_here

# Required for GitHub MCP server  
GITHUB_PERSONAL_ACCESS_TOKEN=your_github_token_here

# Optional: For Apify automation
APIFY_TOKEN=your_apify_token_here

# Filesystem access (set to your project path)
PROJECT_FILESYSTEM_PATH=/path/to/your/project
```

## MCP Servers Included

### 🗃️ **Supabase** (Database Operations)
- **Purpose**: Direct database queries and operations
- **Setup**: Get access token from [Supabase Dashboard](https://supabase.com/dashboard)
- **Usage**: `@supabase` - Query tables, run SQL, manage data

### 🐙 **GitHub** (Repository Management)
- **Purpose**: Create issues, PRs, manage repositories
- **Setup**: Create token at [GitHub Settings](https://github.com/settings/tokens)
- **Permissions**: `repo`, `issues`, `pull_requests`
- **Usage**: `@github` - Create PRs, manage issues, search code

### 🌐 **Netlify** (Deployment Management)
- **Purpose**: Deploy sites, manage builds
- **Setup**: No token required
- **Usage**: `@netlify` - Deploy previews, check build status

### 🤖 **Apify** (Web Automation)
- **Purpose**: Web scraping and automation
- **Setup**: Get token from [Apify Console](https://console.apify.com/settings/integrations)
- **Usage**: `@actors-mcp-server` - Run web scrapers, data extraction

### 📁 **Filesystem** (File Operations)
- **Purpose**: Read/write local files
- **Setup**: Set `PROJECT_FILESYSTEM_PATH` to your project directory
- **Usage**: `@filesystem` - Read files, create directories, manage assets

### 🧠 **Sequential Thinking** (Enhanced Reasoning)
- **Purpose**: Step-by-step problem solving
- **Setup**: No configuration required
- **Usage**: `@sequential-thinking` - Complex problem analysis

### 🎭 **Playwright** (Browser Automation)
- **Purpose**: E2E testing and browser automation
- **Setup**: No configuration required
- **Usage**: `@playwright` - Run tests, automate browser tasks

### 🔍 **Context7** (Semantic Search)
- **Purpose**: Intelligent code and document search
- **Setup**: No configuration required
- **Usage**: `@context7` - Semantic search across codebase

## Security Best Practices

### 🔒 **Token Management**
- **Never commit tokens** to version control
- Use environment variables or system keychain
- Rotate tokens regularly
- Use minimal required permissions

### 🛡️ **Filesystem Access**
- Limit filesystem server to project directories only
- Avoid exposing sensitive system paths
- Review file permissions regularly

### 🚨 **Production Safety**
- Use separate tokens for development/production
- Monitor API usage and rate limits
- Enable audit logging where possible

## Environment-Specific Configuration

### Development
```bash
PROJECT_FILESYSTEM_PATH=~/Development/your-project
GITHUB_PERSONAL_ACCESS_TOKEN=ghp_dev_token
SUPABASE_ACCESS_TOKEN=sbp_dev_token
```

### Production
```bash
PROJECT_FILESYSTEM_PATH=/var/app/current
GITHUB_PERSONAL_ACCESS_TOKEN=ghp_prod_token
SUPABASE_ACCESS_TOKEN=sbp_prod_token
```

## Troubleshooting

### MCP Server Not Loading
1. Check if `~/.claude/mcp.json` exists and is valid JSON
2. Verify all environment variables are set
3. Restart Claude Code completely
4. Check Console for MCP connection errors

### Permission Errors
1. Verify token permissions match server requirements
2. Check if tokens are expired
3. Ensure filesystem paths are accessible

### Performance Issues
1. Limit filesystem server scope to necessary directories
2. Use specific GitHub repository access vs organization-wide
3. Monitor API rate limits

## Advanced Configuration

### Custom MCP Servers
You can add your own MCP servers to the configuration:

```json
{
    "mcpServers": {
        "your-custom-server": {
            "command": "node",
            "args": ["/path/to/your/server.js"],
            "env": {
                "CUSTOM_API_KEY": "${CUSTOM_API_KEY}"
            }
        }
    }
}
```

### Conditional Server Loading
Some servers can be conditionally loaded based on project type:

```json
{
    "mcpServers": {
        "database-server": {
            "command": "npx",
            "args": ["@your/db-server"],
            "env": {
                "DATABASE_URL": "${DATABASE_URL}"
            },
            "disabled": "${DISABLE_DB_MCP}"
        }
    }
}
```

## Integration with Agaile-OS

MCP servers enhance Agaile-OS workflows:

- **`/create-feature`**: Query databases for schema info, create GitHub issues
- **`/db-migrate`**: Direct database operations via Supabase MCP
- **`/typescripter`**: Access filesystem for comprehensive error analysis
- **`/ci-cd`**: Check build status via Netlify MCP
- **`/documenter`**: Search codebases with Context7

## Getting Help

- 📖 [Official MCP Documentation](https://docs.anthropic.com/en/docs/claude-code/mcp)
- 🐛 [Report Issues](https://github.com/Agaile-com/agaile-os-template/issues)
- 💬 [Community Discussions](https://github.com/Agaile-com/agaile-os-template/discussions)

---

*MCP integration enhances your Agaile-OS workflow by connecting Claude directly to your development tools and services.*