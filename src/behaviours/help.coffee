# Description:
#   Generates help commands for Squire.
#
# Commands:
#   help - Gives help for all commands that Squire knows about
#   help <query> - Gives help for the queried command(s)
#
# Notes:
#   These commands are grabbed from comment blocks at the top of each resource.

module.exports = (squire) ->

  squire.hear /// ^
      help \s* (.*)?
    $ ///i, (msg) ->
    cmds = squire.helpCommands()
    if msg.match[1]
      cmds = cmds.filter (cmd) ->
        cmd.match new RegExp msg.match[1], 'i'

    output = cmds.join '\n'
    unless squire.name is 'Squire'
      output = output.replace /(S|s)quire/g, squire.name
    msg.reply output