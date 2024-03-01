# -------------------------------------------------------------------
# Minimal dockerfile from alpine base
#
# Instructions:
# =============
# 1. Create an empty directory and copy this file into it.
#
# 2. Create image with: 
#	docker build --tag timeoff:latest .
#
# 3. Run with: 
#	docker run -d -p 3000:3000 --name alpine_timeoff timeoff
#
# 4. Login to running container (to update config (vi config/app.json): 
#	docker exec -ti --user root alpine_timeoff /bin/sh
# --------------------------------------------------------------------
#FROM alpine:latest as dependencies
FROM python:2.7-alpine as dependencies
ENV PYTHONUNBUFFERED=1
ENV SASS_BINARY_SITE=https://npm.taobao.org/mirrors/node-sass/
RUN apk add --no-cache build-base g++ make
RUN apk add --no-cache gcc musl-dev make
#RUN apk add --upgrade python3 python3-dev build-base
RUN apk add --no-cache \
    nodejs npm

#RUN npm config set python /usr/bin/python2.7
COPY package.json  .
RUN npm install

#FROM node:18-alpine
FROM python:2.7-alpine


LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.docker.cmd="docker run -d -p 3000:3000 --name alpine_timeoff"

RUN apk add --no-cache \
    nodejs npm \
    vim

RUN adduser --system app --home /app
USER app
WORKDIR /app
COPY . /app
COPY --from=dependencies node_modules ./node_modules

CMD npm start

EXPOSE 3000
