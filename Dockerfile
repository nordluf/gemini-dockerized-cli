# docker build . --progress=plain -t hlpr/gdcli

FROM node:24.11.1-slim
RUN apt-get update && apt-get install -y --no-install-recommends && \
    apt-get install -y procps jq && \
    npm install -g @google/gemini-cli && \
    npm cache clean --force && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    echo "alias ll='ls -l --color=auto'" > /home/node/.bash_aliases && chown node:node /home/node/.bash_aliases

COPY seed /
USER node
WORKDIR /app
ENTRYPOINT ["/entrypoint.sh"]
