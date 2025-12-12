# docker build . --progress=plain -t hlpr/gdcli

FROM node:24.12.0-slim
RUN apt-get update && apt-get install -y --no-install-recommends && \
    apt-get install -y procps jq python3 python3-pip git && \
    pip install uv --break-system-packages && \
    npm install -g @google/gemini-cli && \
    pip cache purge && npm cache clean --force && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "alias ll='ls -l --color=auto'" > /home/node/.bash_aliases && chown node:node /home/node/.bash_aliases

USER node
RUN uv tool install specify-cli --from git+https://github.com/github/spec-kit.git && \
    echo '#uv\nexport PATH="/home/node/.local/bin:$PATH"' >> /home/node/.bashrc && \
    uv cache clean && \
    mkdir -p /home/node/specify.init && cd /home/node/specify.init && \
    /home/node/.local/bin/specify init --ai gemini --script sh --here --force --no-git

COPY seed /

WORKDIR /app
ENTRYPOINT ["/entrypoint.sh"]
