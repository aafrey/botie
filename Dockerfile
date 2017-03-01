FROM alpine:latest

RUN apk update && \
    apk add nodejs

ADD . /bot

WORKDIR /bot

CMD ["bin/hubot", "--adapter", "slack", "--name", "white-whale"]
