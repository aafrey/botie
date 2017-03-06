request = require 'request-promise'

module.exports = (robot) ->
  robot.router.post '/funky', (req, res) ->
    data = JSON.parse req.body.payload

    doButton = (action) ->
      action =
        "remove_key": ->
          robot.brain.remove data.actions[0].value
          res.status(201).send("Key: #{data.actions[0].value} has been removed")

        "show_labs": ->
          options =
            method: "POST"
            uri:    "http://gateway:8080/function/lpp_run"
            body:
              email:   data.user.id
              partner: data.channel.name
              image:   data.actions[0].value
            json: true

          request(
            options
          ).then((service) ->
            labsCreated = robot.brain.get('labs_created').parseInt() or 0
            service = service.replace /^\s+|\s+$/g, ""

            robot.brain.set data.user.id, service
            robot.brain.set 'labs_created', labsCreated+1

            service
          ).then((service) ->
            res.status(201).send(
              "text": "Follow the links below to complete this lab..."
              "attachments": [
                { "text": "https://austinfrey.com/#{service}" }
                { "text": "https://austinfrey.com/#{service}/editor" }
            ])
          ).catch((err) -> res.send(err))

      do actions[action]

    doButton(data.callback_id)

