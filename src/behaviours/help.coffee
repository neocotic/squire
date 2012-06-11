# Generates help commands for Squire.
#
# These commands are grabbed from comment blocks at the top of each resource.
#
# help - Displays all of the help commands that Squire knows about.
# help <query> - Displays all help commands that match <query>.

module.exports = (squire) ->
  squire.hear /// ^ help \s* (.*)? $ ///i, (msg) ->
    cmds = squire.helpCommands()
    if msg.match[1]
      cmds = cmds.filter (cmd) ->
        cmd.match new RegExp msg.match[1], 'i'
    emit = cmds.join '\n'
    unless squire.name is 'Squire'
      emit = emit.replace /(S|s)quire/g, squire.name
    msg.reply emit