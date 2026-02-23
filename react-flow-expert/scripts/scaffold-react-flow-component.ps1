param(
  [Parameter(Mandatory = $true)]
  [string]$OutputFile,
  [string]$ComponentName = "FlowCanvas",
  [switch]$UseProvider
)

$component = @"
import { useCallback } from 'react';
import {
  ReactFlow,
  ReactFlowProvider,
  useNodesState,
  useEdgesState,
  addEdge,
  Background,
  Controls,
  MiniMap,
} from '@xyflow/react';
import '@xyflow/react/dist/style.css';

const initialNodes = [
  { id: 'n1', position: { x: 0, y: 0 }, data: { label: 'Node 1' } },
  { id: 'n2', position: { x: 240, y: 120 }, data: { label: 'Node 2' } },
];

const initialEdges = [{ id: 'e-n1-n2', source: 'n1', target: 'n2' }];

function ${ComponentName}Inner() {
  const [nodes, setNodes, onNodesChange] = useNodesState(initialNodes);
  const [edges, setEdges, onEdgesChange] = useEdgesState(initialEdges);

  const onConnect = useCallback(
    (connection) => setEdges((prev) => addEdge(connection, prev)),
    [setEdges]
  );

  return (
    <div style={{ width: '100%', height: '100%' }}>
      <ReactFlow
        nodes={nodes}
        edges={edges}
        onNodesChange={onNodesChange}
        onEdgesChange={onEdgesChange}
        onConnect={onConnect}
        fitView
      >
        <Background />
        <Controls />
        <MiniMap />
      </ReactFlow>
    </div>
  );
}
"@

if ($UseProvider) {
  $component += @"

export default function ${ComponentName}() {
  return (
    <ReactFlowProvider>
      <${ComponentName}Inner />
    </ReactFlowProvider>
  );
}
"@
} else {
  $component += @"

export default function ${ComponentName}() {
  return <${ComponentName}Inner />;
}
"@
}

$parent = Split-Path -Parent $OutputFile
if ($parent -and -not (Test-Path $parent)) {
  New-Item -ItemType Directory -Path $parent -Force | Out-Null
}

Set-Content -Path $OutputFile -Value $component -Encoding UTF8
Write-Output "Created $OutputFile"

