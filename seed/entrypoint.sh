#!/bin/bash
set -euo pipefail

if [[ ! -e "/home/node/.gemini/" ]]; then
  if [[ ! -e "/srv/www/.gemini.store/" ]]; then
    if [[ -d "/srv/gemini.preseed/" ]]; then
      cp -r /srv/gemini.preseed/ /srv/www/.gemini.store
    else
      cp -a /srv/gemini.init/ /srv/www/.gemini.store
    fi

    if [[ ! -f "/srv/www/.gitignore" ]] || ! grep -qxF '.gemini.store' "/srv/www/.gitignore"; then
      echo -e "\n.gemini.store" >> /srv/www/.gitignore
    fi
  fi

  ln -s /srv/www/.gemini.store/ /home/node/.gemini
fi

exec /usr/local/bin/gemini $@
