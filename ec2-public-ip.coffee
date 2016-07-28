module.exports = (robot) ->
  robot.respond /ec2ip/i, (msg) ->
    url = "http://169.254.169.254/latest/meta-data/public-ipv4"
    robot.http(url).get() (err, res, body) ->
      msg.send body
