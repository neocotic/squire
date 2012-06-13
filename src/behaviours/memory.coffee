# Description:
#   Easily inspect Squire's memory.
#
# Commands:
#   show memories - Tells you everything Squire remembers

Util = require 'util'

module.exports = (squire) ->

  squire.hear /// ^ (
        (display | list | show (\s+ me)?)
        (\s+ your)? \s+ memor(ies | y)
      | what \s+ (can | do) \s+ you \s+ remember \??
    ) $ ///i, (msg) ->
    msg.reply Util.inspect squire.brain.memories, false, 4