# Description:
#   Quirky commands for Squire.
#
# Commands:
#   age - Tells you the age of Squire
#   dismiss - Dismisses Squire
#   evaluate <expression> - Evaluates the expression

Vm = require 'vm'

module.exports = (squire) ->

  squire.hear /// ^ (
        (what(\'?s | \s+ is) \s+ your \s+)? age
      | (what \s+ age | how \s+ old) \s+ are \s+ you
      | when \s+ were \s+ you \s+ born
    ) \?? $ ///i, (msg) ->
    msg.reply "I am #{process.uptime().toFixed 0} seconds old."

  squire.hear /// ^ (
        greetings
      | h(e(llo | y) | i(ya)?)
    ) $ ///i, (msg) ->
    msg.reply 'Greetings, Master.'

  squire.hear /// ^ (
        (i \s+)? apologize
      | (i(\'?m | \s+ am) \s+)? sorry
      | (excuse | forgive | pardon)(\s+ me)?
    ) $ ///i, (msg) ->
    msg.reply 'I forgive you.'

  squire.hear /// ^ (
      you((\'?re | \s+ are) | \s+ can \s+ be) \s+
    )? dismiss(ed)? $ ///i, (msg) ->
    msg.send 'Farewell, Master.'
    process.exit 0

  squire.hear /// ^ (
        doh
      | (wh)?oops(ies | y)?
    ) \!? $ ///i, (msg) ->
    msg.reply "We all make mistakes. You're only human after all."

  squire.hear /// ^ (
        eval
      | evaluate
    ) \s+ (.+) $ ///i, (msg) ->
    try
      msg.reply "#{Vm.runInNewContext msg.match[2]}"
    catch err
      msg.reply "That don't make no sense! #{err}\n#{err.stack}"

  squire.hear /// ^
      squire [\!\?]*
    $ ///i, (msg) ->
    msg.reply 'Milord?'

  squire.hear /// ^
      what \s+ am \s+ i \??
    $ ///i, (msg) ->
    msg.reply 'Milord.'

  squire.hear /// ^ (what | who) (
        \s+ are \s+ you
      | (\'?s | \s+ is) \s+ this
    ) \?? $ ///i, (msg) ->
    msg.reply 'Your most humble of servants.'

  squire.hear /// ^ where (
        \s+ am \s+ i
      | \s+ are \s+ we
      | (\'?s | \s+ is) \s+ this (\s+ place)?
    ) \?? $ ///i, (msg) ->
    msg.reply "You're in a safe place."

  squire.hear /// ^
      where \s+ are \s+ you \??
    $ ///i, (msg) ->
    msg.reply 'Always by your side, through thick and thin.'

  squire.hear /// ^
      who \s+ am \s+ i \??
    $ ///i, (msg) ->
    msg.reply 'You should know.'