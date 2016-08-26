cron = require('cron').CronJob

module.exports = (robot) ->
  say = (message) ->
    robot.send {room: "#general"}, message

  new cron '00 30 09 * * 1-5', () ->
    say "就業時間になりました"
  , null, true, "Asia/Tokyo"

  new cron '00 00 12 * * 1-5', () ->
    say "お昼休みになりました"
  , null, true, "Asia/Tokyo"

  new cron '00 00 13 * * 1-5', () ->
    say "お昼休みが終わりました"
  , null, true, "Asia/Tokyo"

  new cron '00 30 17 * * 1-5', () ->
    say "帰宅時間になりました。"
  , null, true, "Asia/Tokyo"
