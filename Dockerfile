FROM alpine:latest

RUN apk update && \
    apk add nodejs

ADD . /bot

WORKDIR /bot

ENV HUBOT_SLACK_TOKEN=xoxb-147979654279-mBZnp0EG3MeLuExT7utXdgcd
CMD ["bin/hubot", "--adapter", "slack"]
