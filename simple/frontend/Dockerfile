# Build stage
FROM node:lts-alpine as builder
# make the 'app' folder the current working directory
WORKDIR /app
ADD package*.json .env ./
# Setup node-prune script and execute cleaning cache
RUN apk add --no-cache curl bash python && cd /tmp && \
  curl -sfL --insecure https://install.goreleaser.com/github.com/tj/node-prune.sh | bash -s -- -b /usr/local/bin && \
  rm -rvf * && \
  echo "yarn cache clean && node-prune" > /usr/local/bin/node-clean && chmod +x /usr/local/bin/node-clean
RUN yarn --frozen-lockfile --non-interactive && node-clean
COPY . ./
# install project dependencies
RUN yarn install --production
RUN yarn build

# Production stage
FROM node:lts-alpine
WORKDIR /app
ADD package*.json .env nuxt.config.js ./
COPY --from=builder ./app/node_modules ./node_modules/
COPY --from=builder ./app/.nuxt ./.nuxt/
COPY --from=builder ./app/static ./static/
# Set environment variables
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=80
CMD [ "yarn", "start" ]
