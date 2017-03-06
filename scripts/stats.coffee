module.exports = (robot) ->

  robot.respond /add lab (.*)/i, id:'addLab', (res) ->
    if robot.brain.get('labs')? then labs = robot.brain.get 'labs'
    else labs = []
    labs.push res.match[1] if res.match[1] not in labs
    robot.brain.set 'labs', labs
    res.reply labs.toString()

  robot.respond /remove lab (.*)/i, id:'removeLab', (res) ->
    labs = robot.brain.get 'labs'
    index = labs.indexOf res.match[1]
    labs.splice index, 1
    robot.brain.set 'labs', labs
    res.reply labs.toString()

  robot.respond /remove key (.*)/i, id:'removeKey', (res) ->
    payload =
      "text": "Are you sure you want to remove the #{res.match[1]} key?"
      "attachments": [ {
        "text": "Choose carefully",
        "fallback": "No labs for you!"
        "callback_id": "remove_key"
        "color": "#3AA3E3"
        "attachment_type": "default"
        "actions": [
          {
            "name": "removeKey"
            "text": "Remove #{res.match[1]}"
            "type": "button"
            "value": res.match[1]
            "style": "danger"
            "confirm":
              "title": "Are you sure?"
              "text": "Last chance!"
              "ok_text": "yes"
              "dismiss_text": "no"
          }
          {
            "name": "removeKey"
            "text": "cancel"
            "type": "button"
            "value": "cancel"
          }
        ]
      } ]

    res.reply payload

  robot.respond /cuckoo/i, (res) ->
    res.reply 'cockledodledoo'
