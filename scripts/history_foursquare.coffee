# Description
#   Use Foursquare API checkin history
#
# Configuration:
#   FOURSQUARE_CLIENT_ID
#   FOURSQUARE_CLIENT_SECRET
#   FOURSQUARE_ACCESS_TOKEN
#
# Commands:
#   hubot 4sqh
#
# Author:
#   o2wsu9


cron = require('cron').CronJob

module.exports = (robot) ->
  config = secrets:
    clientId: process.env.FOURSQUARE_CLIENT_ID
    clientSecret: process.env.FOURSQUARE_CLIENT_SECRET
    accessToken: process.env.FOURSQUARE_ACCESS_TOKEN
    redirectUrl: "localhost"
    locale: 'ja'
    version: '20160722'

  foursquare = require('node-foursquare')(config)
  moment = require("moment")
  moment.locale 'ja',
    weekdays: [
      '日曜日'
      '月曜日'
      '火曜日'
      '水曜日'
      '木曜日'
      '金曜日'
      '土曜日'
    ]
    weekdaysShort: [
      '日'
      '月'
      '火'
      '水'
      '木'
      '金'
      '土'
    ]


  robot.respond /4sq (.*)/i, (msg) ->
    datestr = msg.match[1]

    base = moment().add(-1, 'years')
    if datestr.length == 8
      base = moment(datestr, "YYYYMMDD")
    else if datestr.length == 10
      base = moment(datestr, "YYYY/MM/DD")

    after = base.unix()
    before = base.add(7, 'days').unix()

    params =
      limit: 100
      sort: 'oldestfirst'
      afterTimestamp: after
      beforeTimestamp: before

    foursquare.Users.getCheckins 'self', params, config.secrets.accessToken, (error, response) ->
      if error
        return msg.send error
      checkins = response['checkins']['items']
      for item in checkins
        checkin_time = moment.unix(item['createdAt']).format("YYYY/MM/DD(ddd)HH:mm:ss")
        checkin_name = item['venue']['name']
        msg.send checkin_time + " " + checkin_name
