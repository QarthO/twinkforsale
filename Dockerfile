FROM oven/bun:1

WORKDIR /app

# Install system dependencies required for sharp and other native modules
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    libc6-compat \
    vips-dev

RUN bun install

COPY . .

RUN bunx prisma generate

RUN bun run build && bun run build.server

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENV UPLOADS_DIR=/app/uploads
ENV DATABASE_URL=/app/data/prod.db

# Set entrypoint and command
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bun", "server/entry.node-server.js"]
