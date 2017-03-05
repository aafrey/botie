request = require 'request-promise'
Docker = require 'dockerode'
docker = new Docker({socketPath: '/var/run/docker.sock'})

sendRequest = (sendOptions, response) ->
  request(sendOptions)
    .then((data) ->
      if data[0]? then response.reply(JSON.stringify(data))
      else response.reply('Nothing to show...whawhawhaaaaa!'))
    .catch((err) -> return err)

  sendRequest(options, response)

listAllServices = (response) ->
  options =
    method: 'POST'
    uri: 'http://gateway:8080/function/lpp_list'
    body: {}
    json: true

  sendRequest(options, response)

module.exports = (robot) ->

  robot.respond /list services/i, id:'docker.listServices', (res) ->
    res.reply robot.brain.get(res.envelope.user.name)

  robot.respond /list user (.*) services/i, id:'docker.listUserServices', (res) ->
    res.reply robot.brain.get(res.match[1])

  robot.respond /lab please/i, id:'docker.showLabs', (res) ->
    payload =
        "text": "What do you want to do?"
        "attachments": [ {
            "text": "Choose a lab",
            "fallback": "No game for you!"
            "callback_id": "show_labs"
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

  robot.respond /have a soda/i, (res) ->
    sodasHad = robot.brain.get('totalSodas') * 1 or 0

    if sodasHad > 4
      res.reply 'I am too fizzy'
    else
      res.reply 'sure'

    robot.brain.set 'totalSodas', sodasHad+1

  robot.respond /sleep it off/i, (res) ->
    robot.brain.set 'totalSodas', 0
    res.reply 'zzzzz'
