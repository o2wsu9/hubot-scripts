
cron = require('cron').CronJob

module.exports = (robot) ->
  send = (message) ->
    robot.send {room: "#general"}, message

  robot.respond /github\?/i, (msg) ->
    robot.http('https://status.github.com/api/status.json')
      .get() (err, res, body) ->
        json = JSON.parse(body)
        status = json.status
        msg.send "Github Status is #{status}"

  new cron '00 * * * * 0-6', () ->
    robot.http('https://status.github.com/api/status.json')
      .get() (err, res, body) ->
        json = JSON.parse(body)
        status = json.status
        if status != "good"
          send "Github is down\nhttps://status.github.com/api/status.json"
  , null, true, "Asia/Tokyo"
