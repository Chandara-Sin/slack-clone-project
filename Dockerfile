FROM node:18.17.1-bullseye-slim AS builder
WORKDIR /app

COPY . .
RUN yarn set version ./.yarn/releases/*
RUN yarn workspaces focus --all --production

RUN yarn build

FROM nginx:stable-alpine
COPY --from=builder /app/dist /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
