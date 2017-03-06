payload = () ->
  msg =
    "text": "What do you want to do?"
    "attachments": [ {
      "text": "Choose a lab",
      "fallback": "No labs for you!"
      "callback_id": "run_lab"
      "color": "#3AA3E3"
      "attachment_type": "default"
      "actions": [
        {
          "name": "cancel"
          "text": "cancel"
          "type": "button"
          "value": "cancel"
        }
      ]
    } ]
  get: () ->
    msg
  appendAction: (item) ->
    msg["attachments"][0]["actions"].unshift item

buildButton = (buttonName) ->
  button =
    "name": buttonName
    "text": buttonName
    "type": "button"
    "value": buttonName
    "style": "primary"

module.exports = (buttons) ->
  msgBody = payload()
  actions = (buildButton button for button in buttons)
  msgBody.appendAction action for action in actions
  msgBody.get()
