request = require 'request-promise'
payload = require('./payloadBuilder')

module.exports = (robot) ->

  robot.respond /list services/i, id:'docker.listServices', (res) ->
    labList = robot.brain.get res.envelope.user.id
    labList = (lab.concat(' ') for lab in labList)
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
    ).then((data) ->
      if data.includes "Error"
        res.send "Not seeing it here Harry: `#{JSON.stringify(data)}`"
      else
        res.send JSON.stringify(data)
    ).then( ->
      labList = robot.brain.get res.envelope.user.id
      index = labList.indexOf res.match[1]
      labList.splice index, 1
      robot.brain.set res.envelope.user,id, labList
      res.reply labList.toString()
    ).catch((err) -> res.reply err)

  robot.respond /lab please/i, id:'docker.showLabs', (res) ->
    availableLabs = robot.brain.get 'labs'
    res.reply payload(availableLabs)
