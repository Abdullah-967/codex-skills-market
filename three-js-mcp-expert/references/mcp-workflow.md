# MCP Workflow

Use this sequence when executing Three.js MCP operations.

## Required Sequence by Operation Type

### Adding Objects to Scene

1. Get current scene state:
   - Call `getSceneState` to understand existing objects.

2. Add the object:
   - Call `addObject` with type, position, and optional properties.

3. Verify addition:
   - Call `getSceneState` to confirm object was added with expected ID.

### Moving Objects

1. Get current scene state:
   - Call `getSceneState` to get object IDs and current positions.

2. Resolve target object ID:
   - Extract ID from scene state (never guess IDs).

3. Move the object:
   - Call `moveObject` with resolved ID and new position.

### Removing Objects

1. Get current scene state:
   - Call `getSceneState` to confirm object exists.

2. Stop any active animations:
   - Call `stopRotation` if object is rotating.

3. Remove the object:
   - Call `removeObject` with the object ID.

### Rotation Lifecycle

1. Get current scene state:
   - Call `getSceneState` to confirm object exists.

2. Start rotation:
   - Call `startRotation` with ID and speed.

3. Stop rotation (when done):
   - Call `stopRotation` with ID.

**Important:** Always pair `startRotation` with explicit stop conditions to prevent animation leaks.

## Tool Invocation Patterns

### Scene Query

```
MCP tool: getSceneState
  → Returns: { "objects": [{"id": "cube_1", "type": "cube", "position": {...}}] }
```

### Object Lifecycle

```
MCP tool: addObject
  Args: { type: "cube", position: { x: 0, y: 1, z: 0 }, color: "#ff0000" }
  → Returns: { text: "sent" }

MCP tool: getSceneState
  → Returns: { "objects": [..., {"id": "cube_2", ...}] }

MCP tool: moveObject
  Args: { id: "cube_2", position: { x: 2, y: 1, z: 0 } }
  → Returns: { text: "sent" }

MCP tool: removeObject
  Args: { id: "cube_2" }
  → Returns: { text: "sent" }
```

### Rotation Control

```
MCP tool: startRotation
  Args: { id: "cube_1", speed: 0.01 }
  → Returns: { text: "sent" }

MCP tool: stopRotation
  Args: { id: "cube_1" }
  → Returns: { text: "sent" }
```

## Decision Rules

- Always call `getSceneState` before mutations to resolve IDs.
- Serialize dependent operations (add → rotate, move chains).
- Never assume object IDs; always resolve from scene snapshot.
- Clean up rotations before removing objects.
- Re-sync state after WebSocket reconnection.

## Error Recovery

### "No client connection available"

1. Stop all pending operations.
2. Re-establish WebSocket bridge.
3. Call `getSceneState` to sync.
4. Replay unresolved command queue.

### "No scene state available"

1. Trigger client-side state push.
2. Wait for scene state to populate.
3. Call `getSceneState` to verify.
4. Then proceed with operations.

### Unknown Object ID

1. Call `getSceneState` to get current objects.
2. Find correct ID from snapshot.
3. Retry operation with resolved ID.

## Command Batching Strategy

For multiple related changes:

```
1. getSceneState (once)
2. addObject (object A)
3. addObject (object B)
4. getSceneState (verify both added)
5. startRotation (object A)
6. moveObject (object B)
```

Avoid calling `getSceneState` between every operation—batch reads at logical boundaries.
