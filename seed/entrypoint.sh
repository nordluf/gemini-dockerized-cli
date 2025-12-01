#!/bin/bash
set -euo pipefail

if [[ ! -e "/home/node/.gemini/" ]]; then
  if [[ ! -e "/app/llm/.gemini.store/" ]]; then
    mkdir -p /app/llm/
    cp /PROJECT.md.example /WORKFLOW.md /app/llm/
    cp /gitignore /app/llm/.gitignore
    cp -a /gemini.init/ /app/llm/.gemini.store
    if [[ -d "/app/llm.preseed/" ]]; then
      cp -rf /app/llm.preseed/* /app/llm/.gemini.store
    fi

    if [[ -d "/app/llm.preseed/" && -f "/app/llm.preseed/.env" && ! -f "/app/llm/.env" ]]; then
      cp /app/llm.preseed/.env /app/llm/.env
      if [[ ! -f "/app/.gitignore" ]] || ! grep -qxF './llm.preseed' "/app/.gitignore"; then
        echo "" >> /app/.gitignore
        echo "# Gemini dockerized CLI" >> /app/.gitignore
        echo "./llm.preseed/" >> /app/.gitignore
      fi
    fi

    cp -a /home/node/specify.init/.specify/ /app/llm/.specify/
    for vFILE in /app/llm/.specify/templates/*.md; do
      sed -i 's/\.specify\//llm\/\.specify\//g' "$vFILE"
      sed -i 's/\/specs\//llm\/\/specs\//g' "$vFILE"
    done
    mv /app/llm/.specify/memory/ /app/llm/memory/
    ln -s ../memory/ /app/llm/.specify/memory

    cp -a /home/node/specify.init/.gemini/commands/ /app/llm/.gemini.store/commands/
    for vFILE in /app/llm/.gemini.store/commands/*.toml; do
      sed -i 's/\.specify\//llm\/\.specify\//g' "$vFILE"
    done
  fi

  ln -s /app/llm/.gemini.store/ /home/node/.gemini
fi

if [[ -f "/app/llm/.env" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ $line =~ ^[[:space:]]*# ]]; then
      continue
    fi
    if [[ -n "$line" ]]; then
      export "$line"
    fi
  done < "/app/llm/.env"
fi

if [[ "${CONTEXT7_API_KEY:-}" ]]; then
  jq --arg key "$CONTEXT7_API_KEY" \
    '.mcpServers.context7.headers.CONTEXT7_API_KEY = $key' \
    llm/.gemini.store/settings.json > /tmp/settings.json
  mv -f /tmp/settings.json llm/.gemini.store/settings.json
fi

reset # It is necessary to reset terminal to avoid display issues after previous runs

exec /usr/local/bin/gemini $@
