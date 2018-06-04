FROM nginx:1.13.12-alpine AS base
WORKDIR /app

FROM node:8.9-alpine AS build
WORKDIR /usr/src/app
RUN npm i -g @angular/cli
COPY . .
COPY package.json package.json
RUN npm install --silent
RUN npm run build

FROM base AS final
WORKDIR /app
ENV API_URL='https://changeme.azurewebsites.net'
RUN rm -rf /usr/share/nginx/html
COPY --from=build /usr/src/app/dist /usr/share/nginx/html
