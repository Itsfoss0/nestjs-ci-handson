ARG NODE_VERSION=node:lts-alpine
ARG ENV=production

#Build stage
FROM $NODE_VERSION As build

WORKDIR /usr/src/app

COPY --chown=node:node . .

RUN npm ci && \
    npm run build && \
    ls

USER node


#Stage 2: Creating a minimal image for production
FROM $NODE_VERSION As production

WORKDIR /app

ENV NODE_ENV=$ENV

COPY --chown=node:node package*.json ./

RUN npm ci --only=production

COPY --chown=node:node --from=build /usr/src/app/dist ./dist

RUN ls

EXPOSE 3000

CMD [ "node", "dist/main.js" ]
