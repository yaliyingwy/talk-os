FROM node:latest
MAINTAINER ywen yaliyingwy@gmail.com
WORKDIR /code
COPY . /code
RUN ["/usr/local/bin/npm", "run", "static"]
EXPOSE 7630
CMD ["/usr/local/bin/npm", "start"]