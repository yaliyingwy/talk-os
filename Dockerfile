FROM node:latest
MAINTAINER ywen yaliyingwy@gmail.com
WORKDIR /code
COPY . /code
WORKDIR /code/talk-account
RUN ["/usr/local/bin/npm", "run", "static"]
WORKDIR /code/talk-web
RUN ["/usr/local/bin/npm", "run", "static"]
EXPOSE 7001
WORKDIR /code
CMD ["/usr/local/bin/npm", "run", "start"]