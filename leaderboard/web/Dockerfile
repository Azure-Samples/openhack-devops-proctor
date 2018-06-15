FROM node:8-alpine AS build
WORKDIR /usr/src/app
RUN npm i -g @angular/cli
COPY . .
RUN npm install --silent
RUN npm run build

FROM nginx:1.13.12-alpine
WORKDIR /app
ENV API_URL='https://devopsohfun.azurewebsites.net/api/GetTeamsStatus'
RUN rm -rf /usr/share/nginx/html
# COPY ./dist /usr/share/nginx/html # Useful for local builds
COPY --from=build /usr/src/app/dist /usr/share/nginx/html
