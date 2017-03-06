request = require 'request-promise'

payload = () ->
  msg =
    "text": "What do you want to do?"
    "attachments": [ {
      "text": "Choose a lab",
      "fallback": "No labs for you!"
      "callback_id": "run_lab"
      "color": "#3AA3E3"
      "attachment_type": "default"
      "actions": []
    } ]
  get: () ->
    msg
  set: (item) ->
    msg["attachments"][0]["actions"] = item

buildButton = (buttonName) ->
  button =
    "name": buttonName
    "text": buttonName
    "type": "button"
    "value": buttonName

module.exports = (robot) ->

  robot.respond /list services/i, id:'docker.listServices', (res) ->
    labList = robot.brain.get res.envelope.user.id
    res.reply labList.toString()

  robot.respond(
    /list user (.*) services/i,
    id:'docker.listUserServices', (res) ->
      userID = robot.brain.userForName(res.match[1])["id"]
      labList = robot.brain.get userID
      res.reply labList.toString()
  )

  robot.respond /remove service (.*)/i, id:'removeService', (res) ->
    options =
      method: 'POST'
      uri: 'http://gateway:8080/function/lpp_remove'
      body:
        service: res.match[1]
      json: true

    request(
      options
    ).then((data) -> res.reply JSON.stringify(data)
    ).then( ->
      labList = robot.brain.get res.envelope.user.id
      index = labList.indexOf res.match[1]
      labList.splice index, 1
      robot.brain.set res.envelope.user,id, labList
      res.reply labList.toString()
    ).catch((err) -> res.reply err)

  robot.respond /lab please/i, id:'docker.showLabs', (res) ->
    msgBody = payload()
    availableLabs = robot.brain.get 'labs'
    actions = (buildButton button for button in availableLabs)
    msgBody.set(actions)
    res.reply msgBody.get()
