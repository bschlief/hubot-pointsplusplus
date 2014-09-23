# Description:
#   Give, Take and List User Points
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot scoreboard - list all points for all known users
#   hubot scoreboard reset - clear all points
#   hubot score <username> - list how many points <username> has
#   hubot <name>++ - Add a point to a user
#   hubot <name>-- - Subtract a point from a user
#   hubot <name>+=4 - Add four points to a user
#   hubot <name>-=4 - Subtract four points from a user
#
# Author:
#   Bryan Schlief
#
# Credits:
#   Based on the hubot-points script by brettlangdon
#   (https://github.com/github/hubot-scripts)
#

points = {}

award_points = (msg, username, pts) ->
    points[username] ?= 0
    points[username] += parseInt(pts)
    msg.send pts + ' awarded to ' + username

deduct_points = (msg, username, pts) ->
    points[username] ?= 0
    points[username] -= parseInt(pts)
    msg.send pts + ' deducted from ' + username

save = (robot) ->
    robot.brain.data.points = points

module.exports = (robot) ->
    robot.brain.on 'loaded', ->
        points = robot.brain.data.points or {}

    robot.hear /(.*?)\s?\+\+\s?;?/i, (msg) ->
        award_points(msg, msg.match[1].trim(), 1)
        save(robot)

    robot.hear /(.*?)\s?--\s?;?/i, (msg) ->
        deduct_points(msg, msg.match[1].trim(), 1)
        save(robot)

    robot.hear /(.*?)\s?\+=\s?(\d+);?/i, (msg) ->
        award_points(msg, msg.match[1].trim(), msg.match[2])
        save(robot)

    robot.hear /(.*?)\s?-=\s?(\d+);?/i, (msg) ->
        deduct_points(msg, msg.match[1].trim(), msg.match[2])
        save(robot)

    robot.respond /scoreboard reset/i, (msg) ->
        points = {}
        save(robot)

    robot.hear /score (.*)\??/i, (msg) ->
        username = msg.match[1].trim()
        points[username] ?= 0
        msg.send username + ' has ' + points[username] + ' points'

    robot.hear /scoreboard/i, (msg) ->
        for k,v of points
            msg.send k + " " + v
