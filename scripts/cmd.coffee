child_process = require('child_process')

allow_cmd =
  "uptime": "uptime"
  "w": "w"
  "df": "df -Th"

module.exports = (robot) ->
  robot.respond /cmd (.*)/i, (msg) ->
    cmd_name = msg.match[1]
    if cmd_name of allow_cmd
      child_process.exec allow_cmd[cmd_name], (error, stdout, stderr) ->
        msg.send stdout
        msg.send stderr
        msg.send error
