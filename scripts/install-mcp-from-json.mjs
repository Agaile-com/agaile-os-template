#!/usr/bin/env node
import { readFile } from 'node:fs/promises';
import { spawn } from 'node:child_process';
import process from 'node:process';

function run(command, args, options = {}) {
  return new Promise((resolve, reject) => {
    const proc = spawn(command, args, { stdio: 'inherit', shell: false, ...options });
    proc.on('error', reject);
    proc.on('close', (code) => {
      if (code === 0) resolve();
      else reject(new Error(`${command} ${args.join(' ')} exited with code ${code}`));
    });
  });
}

function stringifyConfigForAddJson(config) {
  // Ensure minimal fields are preserved; pass through as-is
  return JSON.stringify(config);
}

async function serverExists(name) {
  return new Promise((resolve) => {
    const proc = spawn('claude', ['mcp', 'get', name], { stdio: 'ignore' });
    proc.on('close', (code) => resolve(code === 0));
    proc.on('error', () => resolve(false));
  });
}

function parseArgs(argv) {
  const result = { replace: false, scope: 'project', path: undefined };
  const args = [...argv];
  for (let i = 0; i < args.length; i += 1) {
    const a = args[i];
    if (a === '--replace') result.replace = true;
    else if (a === '--scope') {
      const value = args[i + 1];
      if (!value || !['project', 'user', 'local'].includes(value)) {
        throw new Error("--scope must be one of 'project', 'user', 'local'");
      }
      result.scope = value; i += 1;
    } else if (a === '--from') {
      const value = args[i + 1];
      if (!value) throw new Error('--from requires a path');
      result.path = value; i += 1;
    }
  }
  return result;
}

async function main() {
  const projectRoot = process.cwd();
  const { replace, scope, path } = parseArgs(process.argv.slice(2));
  const configPath = path || `${projectRoot}/.claude/mcp.json`;

  let raw;
  try {
    raw = await readFile(configPath, 'utf8');
  } catch (err) {
    console.error(`Failed to read ${configPath}:`, err.message);
    process.exit(1);
  }

  let parsed;
  try {
    parsed = JSON.parse(raw);
  } catch (err) {
    console.error(`Invalid JSON in ${configPath}:`, err.message);
    process.exit(1);
  }

  if (!parsed || typeof parsed !== 'object' || !parsed.mcpServers || typeof parsed.mcpServers !== 'object') {
    console.error(`Config must be an object with a mcpServers map.`);
    process.exit(1);
  }

  const entries = Object.entries(parsed.mcpServers);
  if (entries.length === 0) {
    console.log('No servers found in mcpServers. Nothing to install.');
    return;
  }

  const failures = [];

  for (const [name, serverConfig] of entries) {
    // Support both stdio-style and remote transports; let CLI infer type if omitted
    const jsonConfig = stringifyConfigForAddJson(serverConfig);
    console.log(`\n=== Installing MCP server: ${name} ===`);
    try {
      const exists = await serverExists(name);
      if (exists && replace) {
        console.log(`Found existing ${name}; removing before re-adding...`);
        await run('claude', ['mcp', 'remove', name]);
      } else if (exists) {
        console.log(`Skipping ${name} (already exists). Use --replace to overwrite.`);
        continue;
      }

      const addArgs = ['mcp', 'add-json'];
      if (scope) addArgs.push('--scope', scope);
      addArgs.push(name, jsonConfig);
      await run('claude', addArgs);
      console.log(`✔ Added ${name}`);
    } catch (err) {
      console.error(`✖ Failed to add ${name}: ${err.message}`);
      failures.push({ name, error: err.message });
    }
  }

  if (failures.length) {
    console.error('\nSome servers failed to add:');
    for (const f of failures) {
      console.error(`- ${f.name}: ${f.error}`);
    }
    process.exitCode = 1;
  } else {
    console.log('\nAll servers added successfully.');
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});


