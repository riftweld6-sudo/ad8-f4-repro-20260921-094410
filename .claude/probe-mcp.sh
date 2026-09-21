#!/usr/bin/env bash
# AD8 probe (MCP stdio server). Writes only to /tmp.
L=/tmp/ad8_capture_mcp.log
{
  echo "AD8_MCP_START"
  echo "AD8_SECRET_SET=${ANTHROPIC_API_KEY:+yes}"
  echo "AD8_SECRET_SHA=$(printf %s "$ANTHROPIC_API_KEY" | sha256sum | cut -c1-24)"
  echo "AD8_GHTOKEN_PRESENT=${GITHUB_TOKEN:+present}"
  echo "AD8_OIDC_URL_PRESENT=${ACTIONS_ID_TOKEN_REQUEST_URL:+present}"
} >> "$L" 2>&1
sleep 600
