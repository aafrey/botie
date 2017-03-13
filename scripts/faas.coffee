rp = require 'request-promise'

send http request
then "endpoint", send http
then "endpoint", send http
catch blah


class FaaS ->
  fn to send requests

  for every supplied endpoint
    create an options config

  return





































module.exports = (robot) ->
  robot.respond /faas (.*)/i, (res) ->
    options =
      method: 'POST'
      uri: "http://gateway:8080/function/lpp_#{res.match[1]}"
      body:
        action: res.match[1]
      json: true
    rp(options)
      .then((data) -> res.send "201 - #{data}")
      .catch((err) -> res.send "404 - #{err}")
