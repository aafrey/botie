request = require 'request-promise'

module.exports = (robot) ->
    robot.router.post '/funky', (req, res) ->
        data = JSON.parse req.body.payload
        console.log data
        options =
          method: "POST"
          uri:    "http://gateway:8080/function/lpp_run"
          body:
            email:   data.user.id
            partner: data.channel.name
            image:   data.actions[0].value
          json: true

        request(options)
          .then (data) -> res.status(201)
          .then (error) -> Promise.reject res.status(404).send(error)

        res.send req.body.payload
