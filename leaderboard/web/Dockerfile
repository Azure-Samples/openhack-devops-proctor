FROM node:8-alpine AS build
WORKDIR /usr/src/app
RUN npm i -g @angular/cli
COPY . .
ARG FUNCTION_NAME
RUN grep -l 'devopsoh2subproc1fun' src/environments/*.ts | xargs sed -i.bak -e "s|devopsoh2subproc1fun|$FUNCTION_NAME|g"
RUN npm install --silent
RUN npm run build:prod

FROM nginx:1.13.12-alpine
RUN rm -rf /usr/share/nginx/html
WORKDIR /usr/share/nginx/html
# COPY ./dist . # Useful for local builds
COPY --from=build /usr/src/app/dist .
