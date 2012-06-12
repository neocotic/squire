# Generates help commands for Squire.
#
# These commands are grabbed from comment blocks at the top of each resource.
#
# help - Gives help for all commands that Squire knows about
# help <command> - Gives help for the command

module.exports = (squire) ->

  squire.hear /// ^
      help \s* (.*)?
    $ ///i, (msg) ->
    cmds = squire.helpCommands()
    if msg.match[1]
      cmds = cmds.filter (cmd) ->
        cmd.match new RegExp msg.match[1], 'i'
    emit = cmds.join '\n'
    unless squire.name is 'Squire'
      emit = emit.replace /(S|s)quire/g, squire.name
    msg.reply emit