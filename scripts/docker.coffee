Docker = require 'dockerode'
docker = new Docker({socketPath: '/var/run/docker.sock'})

listServices = () ->
  docker.listServices opts, (err, data) ->
    return data

listContainers = () ->
  docker.listContainers (err, containers) ->
    return containers

startService = (opts) ->
  docker.createService opts, (err, service) ->
    return service

module.exports = (robot) ->
  robot.respond /list services/i, (res) ->
    res.reply listServices()

  robot.hear /list containers/i, (res) ->
    res.reply listContainers()

  robot.respond /start service (.*)/i, (res) ->
    service = res.match[1]
    res.reply startService(service)
