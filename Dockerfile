FROM alpine:latest

RUN apk update && \
    apk add nodejs

ADD . /bot

WORKDIR /bot

ENV HUBOT_SLACK_TOKEN=xoxb-YOUR_SLACK_TOKEN
CMD ["bin/hubot", "--adapter", "slack"]
