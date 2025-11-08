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

exec /usr/local/bin/gemini $@
