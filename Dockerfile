# docker build . --progress=plain -t hlpr/gdcli

FROM node:26.4.0
RUN apt-get update && apt-get install -y --no-install-recommends && \
    apt-get install -y procps jq curl git less && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    npm install -g @fission-ai/openspec && rm -rf /root/.npm && \
    echo "alias ll='ls -l --color=auto'" > /home/node/.bash_aliases && chown node:node /home/node/.bash_aliases

USER node

RUN curl -fsSL https://antigravity.google/cli/install.sh | bash

COPY seed /

WORKDIR /app
ENTRYPOINT ["/entrypoint.sh"]
