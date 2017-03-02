module.exports = (robot) ->
    robot.router.post '/funky', (req, res) ->
        console.log req.params
        res.send 'OK'
