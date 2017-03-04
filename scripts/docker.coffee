request = require 'request-promise'
Docker = require 'dockerode'
docker = new Docker({socketPath: '/var/run/docker.sock'})

module.exports = (robot) ->
  robot.respond /list services/i, (res) ->
    options =
      method: "POST"
      uri: "http://gateway:8080/function/lpp_list"
      body:
        label: "email=#{res.envelope.user.id}"
      json: true

    request(options)
      .then (data) -> res.reply(JSON.stringify(data))

    #docker.listServices (err, services) ->
    #  res.reply JSON.stringify(services)

  robot.respond /list containers/i, (res) ->
    console.log res.envelope.user.name
    docker.listContainers (err, containers) ->
      res.reply JSON.stringify(containers)

  robot.respond /start service (.*)/i, (res) ->
    docker.createService opts, (err, service) ->
      res.reply JSON.stringify(service)

  robot.respond /scenario please/i, (res) ->
    payload =
        "text": "What do you want to do?"
        "attachments": [ {
            "text": "Choose a scenario",
            "fallback": "No game for you!"
            "callback_id": "wopr_game"
            "color": "#3AA3E3"
            "attachment_type": "default"
            "actions": [
                {
                  "name": "test"
                  "text": "recommendations"
                  "type": "button"
                  "value": "RECOMMENDATIONS"
                }
                {
                  "name": "test"
                  "text": "magento"
                  "type": "button"
                  "value": "magento"
                  "confirm":
                      "title": "Are you sure?"
                      "text": "Really?"
                      "ok_text": "yes"
                      "dismiss_text": "no"
                }
                {
                  "name": "text"
                  "text": "cancel"
                  "type": "button"
                  "value": "cancel"
                  "style": "danger"
                }
            ]
        } ]

    res.reply payload
