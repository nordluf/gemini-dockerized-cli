#!/bin/bash
set -euo pipefail

if [[ ! -e "/home/node/.gemini/" ]]; then
  if [[ ! -e "/app/.gemini.store/" ]]; then
    if [[ -d "/srv/gemini.preseed/" ]]; then
      cp -r /srv/gemini.preseed/ /app/.gemini.store
    else
      cp -a /srv/gemini.init/ /app/.gemini.store
    fi

    if [[ ! -f "/app/.gitignore" ]] || ! grep -qxF '.gemini.store' "/app/.gitignore"; then
      echo -e "\n.gemini.store" >> /app/.gitignore
    fi
  fi

  ln -s /app/.gemini.store/ /home/node/.gemini
fi

exec /usr/local/bin/gemini $@
