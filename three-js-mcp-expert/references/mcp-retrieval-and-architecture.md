# Three.js MCP Retrieval and Architecture Map

## Source-of-truth collected

- Repository: `https://github.com/locchung/three-js-mcp`
- Files inspected:
  - `README.md`
  - `package.json`
  - `tsconfig.json`
  - `src/main.ts`
  - `build/main.js`

## Retrieval SOP (advanced-first)

1. Enumerate connected MCP resources/tooling.
2. If MCP initialization fails, inspect MCP config and startup command.
3. Pull server source and inspect tool handlers before attempting app changes.
4. Validate build/runtime behavior on target OS.
5. Extract only architecture, edge conditions, and operational limits.

## Verified architecture

- Transport topology:
  - MCP server over stdio (`StdioServerTransport`)
  - Separate WebSocket bridge (`WebSocketServer`) on port `8082`
- State model:
  - Single in-memory `sceneState`
  - Single active `clientConnection`
  - Scene updates arrive as JSON messages from connected client
- MCP capabilities exposed:
  - `tools`
  - `prompts`
  - `resources` not implemented
- Tool contract:
  - Server forwards action commands to WS client and returns simple text response (`sent` or error text)

## Tool surface and command mapping

- `addObject` -> `{ action: "addObject", ...input }`
- `moveObject` -> `{ action: "moveObject", ...input }`
- `removeObject` -> `{ action: "removeObject", ...input }`
- `startRotation` -> `{ action: "startRotation", id, speed }`
- `stopRotation` -> `{ action: "stopRotation", id }`
- `getSceneState` -> returns `sceneState.data` JSON string when available

## Prompt behavior

- Prompt: `asset-creation-strategy`
- Operational implication:
  - Read scene first (`getSceneState`)
  - Extract IDs from scene before issuing mutations

## Verified runtime constraints

- `npm run build` fails on Windows due to `chmod` in build script.
- `npx three-js-mcp` may fail depending on package publishing/bin wiring.
- `node build/main.js` works after TypeScript compilation.

## Practical operating model

- Treat MCP server as a thin command relay.
- Put orchestration intelligence in the calling agent/application:
  - command sequencing
  - retries
  - idempotency
  - scene conflict detection
  - lifecycle cleanup
