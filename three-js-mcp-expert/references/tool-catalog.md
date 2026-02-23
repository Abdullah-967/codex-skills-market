# Three.js MCP Tool Catalog

Complete reference of all Three.js MCP tools with parameters and usage guidance.

## Server Configuration

**Transport:** stdio (`StdioServerTransport`)
**Client Bridge:** WebSocket on port 8082 (configurable)
**State Model:** Single in-memory scene state

## Tools

### addObject

Add a 3D object to the scene.

**Risk Level:** Scene-modify

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| type | string | Yes | Object type: "cube", "sphere", "cylinder", etc. |
| position | object | Yes | `{ x: number, y: number, z: number }` |
| color | string | No | Hex color code (e.g., "#ff0000") |
| scale | object | No | `{ x: number, y: number, z: number }` |

**Returns:**
```json
{ "text": "sent" }
```

**Notes:**
- Object ID is assigned by the client, not returned directly.
- Call `getSceneState` after to get the assigned ID.

---

### moveObject

Move an existing object to a new position.

**Risk Level:** Scene-modify

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| id | string | Yes | Object ID from scene state |
| position | object | Yes | `{ x: number, y: number, z: number }` |

**Returns:**
```json
{ "text": "sent" }
```

**Precondition:** Object must exist in scene. Resolve ID from `getSceneState` first.

---

### removeObject

Remove an object from the scene.

**Risk Level:** Scene-modify (destructive)

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| id | string | Yes | Object ID from scene state |

**Returns:**
```json
{ "text": "sent" }
```

**Best Practice:** Stop any active rotation before removing.

---

### startRotation

Start rotating an object around the Y axis.

**Risk Level:** Animation-start

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| id | string | Yes | Object ID from scene state |
| speed | number | No | Rotation speed (default: 0.01) |

**Returns:**
```json
{ "text": "sent" }
```

**Important:** Always pair with `stopRotation` to prevent animation leaks.

---

### stopRotation

Stop an object's rotation.

**Risk Level:** Animation-stop

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| id | string | Yes | Object ID from scene state |

**Returns:**
```json
{ "text": "sent" }
```

---

### getSceneState

Get the current scene state snapshot.

**Risk Level:** Read-only

**Parameters:** None

**Returns:**
```json
{
  "objects": [
    {
      "id": "cube_1",
      "type": "cube",
      "position": { "x": 0, "y": 1, "z": 0 },
      "rotation": { "x": 0, "y": 0, "z": 0 },
      "color": "#ff0000"
    }
  ]
}
```

**Error States:**
- `"No scene state available"` — Client hasn't pushed state yet.

**Use When:**
- Before any mutation to resolve object IDs.
- After mutations to verify changes.
- On reconnection to sync state.

## Prompts

### asset-creation-strategy

Guidance for scene-aware object creation workflow.

**Arguments:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| scene | string | No | Current scene context |

**Returns:** Strategy guidance for creating objects based on existing scene composition.

## Risk Level Reference

| Level | Description | Action Required |
|-------|-------------|-----------------|
| Read-only | Safe to call anytime | None |
| Scene-modify | Changes scene state | Verify ID first |
| Animation-start | Starts continuous animation | Plan stop condition |
| Animation-stop | Stops animation | None |

## Command Flow Patterns

### Safe Object Lifecycle

```
getSceneState → addObject → getSceneState → [use object] → stopRotation → removeObject
```

### Safe Rotation Lifecycle

```
getSceneState → startRotation → [wait/condition] → stopRotation
```

### Safe Multi-Object Update

```
getSceneState → moveObject(A) → moveObject(B) → getSceneState (verify)
```

## Known Limitations

1. **No command acknowledgement** — `"sent"` doesn't confirm client execution.
2. **Single client** — Only one WebSocket client supported at a time.
3. **No transactions** — Commands are not atomic; partial failures possible.
4. **No ID return** — `addObject` doesn't return the assigned ID directly.
