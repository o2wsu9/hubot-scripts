# curl "https://trello.com/1/boards/#{boardid}/lists?key=#{key}&token=#{token}&fields=name"
# trelloに登録しているリストのカード一覧を定時にリマインドします。
# HUBOT_TRELLO_KEY
# HUBOT_TRELLO_TOKEN
# HUBOT_TRELLO_LIST_ID

cron = require('cron').CronJob
trello = require("node-trello")

config =
  key: process.env.HUBOT_TRELLO_KEY
  token: process.env.HUBOT_TRELLO_TOKEN
  list_id: process.env.HUBOT_TRELLO_LIST_ID

module.exports = (robot) ->

  t = new trello(config.key, config.token)
  unless config.list_id?
    robot.logger.error 'process.env.HUBOT_TRELLO_LIST_ID is not defined'
    return

  robot.respond /ts/i, (msg) ->
    t.get "/1/lists/#{config.list_id}/cards", (err, cards) ->
      if err
        msg.send "対象のカードリストを取得できませんでした"
        robot.logger.error err
        return

      titles = []
      for card in cards
        titles.push card.name
      msg.send titles.join("\n")

  new cron '00 30 8 * * 0-6', () ->
    t.get "/1/lists/#{config.list_id}/cards", (err, cards) ->
      if err
        msg.send "対象のカードリストを取得できませんでした"
        robot.logger.error err
        return

      titles = []
      for card in cards
        titles.push card.name
      robot.send {room: "#general"}, titles.join("\n")
  , null, true, "Asia/Tokyo"
