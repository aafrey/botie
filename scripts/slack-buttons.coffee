request = require 'request-promise'

module.exports = (robot) ->
  robot.router.post '/funky', (req, res) ->
    data = JSON.parse req.body.payload

    doButton = (action) ->
      actions =
        "remove_key": ->
          if data.actions[0].value is 'cancel' then res.status(
            201
          ).send('Hallelujah!')

          robot.brain.remove data.actions[0].value
          res.status(
            201
          ).send("Key: #{data.actions[0].value} has been removed")

        "run_lab": ->
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
            if robot.brain.get(data.user.id)?
              serviceList = robot.brain.get data.user.id
            else serviceList = []
            console.log serviceList
            service = service.replace /^\s+|\s+$/g, ""
            serviceList.push service if service not in serviceList
            robot.brain.set data.user.id, serviceList
            res.status(
              201
            ).send(
              "text": "Follow the links below to complete this lab..."
              "attachments": [
                { "text": "https://austinfrey.com/#{service}" }
                { "text": "https://austinfrey.com/#{service}/editor" }
              ]
            )
          ).catch((err) -> res.send(err))

      do actions[action]

    doButton(data.callback_id)

