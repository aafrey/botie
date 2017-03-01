Docker = require 'dockerode'
docker = new Docker({socketPath: '/var/run/docker.sock'})

module.exports = (robot) ->
  robot.respond /list services/i, (res) ->
    docker.listServices (err, services) ->
      res.reply JSON.stringify(services)

  robot.respond /list containers/i, (res) ->
    docker.listContainers (err, containers) ->
      res.reply JSON.stringify(containers)

  robot.respond /start service (.*)/i, (res) ->
    docker.createService opts, (err, service) ->
      res.reply JSON.stringify(service)
