# Easily inspect the persisted memory.
#
# show memories - Displays what the squire remembers.

Util = require 'util'

module.exports = (squire) ->
squire.hear /// ^ (
      show \s* memor(ies|y)
    | what \s* (can|do) \s* you \s* remember \??
  ) $ ///i, (msg) ->
  msg.reply Util.inspect squire.brain.memories, false, 4