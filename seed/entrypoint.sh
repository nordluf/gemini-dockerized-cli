#!/bin/bash
set -euo pipefail

if [[ ! -e "/home/node/.gemini/" ]]; then
  if [[ ! -e "/app/llm/.gemini.store/" ]]; then
    mkdir -p /app/llm/
    if [[ -d "/preseed/" ]]; then
      cp -r /preseed/ /app/llm/.gemini.store
    else
      cp -a /gemini.init/ /app/llm/.gemini.store
    fi

    if [[ ! -f "/app/.gitignore" ]] || ! grep -qxF './llm/.gemini.store' "/app/.gitignore"; then
      echo -e "\n./llm/.gemini.store" >> /app/.gitignore
    fi
  fi

  ln -s /app/llm/.gemini.store/ /home/node/.gemini
fi

if [[ "${CONTEXT7_API_KEY:-}" ]]; then
  jq --arg key "$CONTEXT7_API_KEY" \
    '.mcpServers.context7.headers.CONTEXT7_API_KEY = $key' \
    llm/.gemini.store/settings.json > /tmp/settings.json
  mv -f /tmp/settings.json llm/.gemini.store/settings.json
fi

reset # It is necessary to reset terminal to avoid display issues after previous runs

exec /usr/local/bin/gemini $@
