#!/bin/bash
set -euo pipefail

if [[ ! -e "/home/node/.gemini/" ]]; then
  if [[ ! -e "/app/.agent/.store/" ]]; then
    mkdir -p /home/node/.config/openspec/ /app/.agent/
#    cp /gitignore /app/.antigravity.store/.gitignore
    cp -a /openspec.json /home/node/.config/openspec/config.json
    cp -a /gemini.init/ /app/.agent/.store/
    cp /gitignore /app/.agent/.gitignore
    if [[ -d "/preseed/" ]]; then
      test -f /preseed/.agent/.store/antigravity-cli/antigravity-oauth-token && \
        cp -f /preseed/.agent/.store/antigravity-cli/antigravity-oauth-token /app/.agent/.store/antigravity-cli/
      test -f /preseed/.agent/.store/antigravity-cli/installation_id && \
        cp -f /preseed/.agent/.store/antigravity-cli/installation_id /app/.agent/.store/antigravity-cli/
    fi
    openspec init --tools antigravity --force --profile custom
  fi

  ln -s /app/.agent/.store/ /home/node/.gemini
fi

if [[ -f "/app/.agent/.store/.env" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ $line =~ ^[[:space:]]*# ]]; then
      continue
    fi
    if [[ -n "$line" ]]; then
      export "$line"
    fi
  done < "/app/.agent/.store/.env"
fi

# reset # It is necessary to reset terminal to avoid display issues after previous runs

exec /home/node/.local/bin/agy $@
