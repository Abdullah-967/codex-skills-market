param(
    [ValidateSet("streamable-http", "http")]
    [string]$Transport = "streamable-http",
    [string]$ServerUrl = "https://mcp.vapi.ai/mcp",
    [string]$ApiKeyEnvVar = "VAPI_API_KEY",
    [string]$ServerName = "vapi"
)

$config = @{
    mcpServers = @{
        $ServerName = @{
            type = $Transport
            url = $ServerUrl
            headers = @{
                "x-vapi-api-key" = '${env:' + $ApiKeyEnvVar + '}'
            }
        }
    }
}

$json = $config | ConvertTo-Json -Depth 10
Write-Output $json
