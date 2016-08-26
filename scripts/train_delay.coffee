cheerio = require 'cheerio-httpcli'
cronJob = require('cron').CronJob

module.exports = (robot) ->

  delay_train = (room) ->
    url = 'http://transit.loco.yahoo.co.jp/traininfo/gc/13/'

    cheerio.fetch url, (err, $, res) ->
      res_array = []
      if $('.elmTblLstLine.trouble').find('a').length == 0
        robot.send {room: room}, "事故や遅延情報はありません"
        return

      $('.elmTblLstLine.trouble a').each ->
        url = $(this).attr('href')
        cheerio.fetch url, (err, $, res) ->
          title = "◎ #{$('h1').text()} #{$('.subText').text()}"
          result = ""
          $('.trouble').each ->
            trouble = $(this).text().trim()
            result += " - " + trouble + "\r\n"
            robot.send {room: room}, "#{title}\r\n#{result}"

  robot.respond /遅延/i, (msg) ->
    room = msg.message.user.room
    delay_train(room)

  new cronJob '00 30 8 * * 1-5', () ->
    delay_train("#general")
  , null, true, "Asia/Tokyo"
