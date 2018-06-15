FROM node:8-alpine AS build
WORKDIR /usr/src/app
RUN npm i -g @angular/cli
COPY . .
ARG FUNCTION_NAME
RUN sh inject.sh
RUN npm install --silent
RUN npm run build

FROM nginx:1.13.12-alpine
WORKDIR /app
RUN rm -rf /usr/share/nginx/html
# COPY ./dist /usr/share/nginx/html # Useful for local builds
COPY --from=build /usr/src/app/dist /usr/share/nginx/html
