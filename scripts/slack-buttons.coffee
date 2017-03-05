request = require 'request-promise'

module.exports = (robot) ->
  robot.router.post '/funky', (req, res) ->
    data = JSON.parse req.body.payload
    options =
      method: "POST"
      uri:    "http://gateway:8080/function/lpp_run"
      body:
        email:   data.user.id
        partner: data.channel.name
        image:   data.actions[0].value
      json: true

    request(options)
      .then((service) ->
        service = service.replace /^\s+|\s+$/g, ""
        robot.brain.set data.user.name, service
        service)
      .then((service) ->
        res.status(201).send(
          "text": "Follow the links below to complete this lab..."
          "attachments": [
            { "text": "https://austinfrey.com/#{service}" }
            { "text": "https://austinfrey.com/#{service}/editor" }
          ]))
      .catch((err) -> res.send(err))

