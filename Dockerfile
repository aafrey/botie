FROM alpine:latest

RUN apk update && \
    apk add nodejs

ADD . /bot

WORKDIR /bot
RUN npm install

EXPOSE 8080
CMD ["bin/hubot", "--adapter", "slack", "--name", "white-whale"]
