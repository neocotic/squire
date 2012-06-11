# Utility commands surrounding Squire life.
#
# age - Says the age of Squire.
# dismiss - Dismisses Squire.
# evaluate <expression> - Evaluates the given expression.
# time - Says the current time.

Vm = require 'vm'

module.exports = (squire) ->
  squire.hear /// ^ (
        (what \s* is \s* your \s*)? age
      | (what \s* age|how \s* old) \s* are \s* you
    ) \?? $ ///i, (msg) ->
    msg.reply "I am #{process.uptime().toFixed 0} seconds old."

  squire.hear /// ^ (
        he(llo|y)
      | hi
      | greetings
    ) $ ///i, (msg) ->
    msg.reply 'Greetings, Master.'

  squire.hear /// ^ (
        (i \s*)? apologize
      | (i(\'m|\s* am) \s*)? sorry
      | (forgive|pardon)(\s* me)?
    ) $ ///i, (msg) ->
    msg.reply 'I forgive you.'

  squire.hear /// ^ (
        (what \s* is \s* the \s*)? (date|time)
      | what \s* (date|time) \s* is \s* it
    ) (\s* now)? \?? $ ///i, (msg) ->
    msg.reply "I reckon it's about #{new Date()}."

  squire.hear /// ^ (
      you((\'re|\s* are)|can \s* be) \s*
    )? dismiss(ed)? $ ///i, (msg) ->
    msg.send 'Farewell, Master.'
    process.exit 0

  squire.hear /// ^ (
      doh
    | (wh)?oops(ies|y)?
  ) \!? $ ///i, (msg) ->
    msg.reply 'We all make mistakes.'

  squire.hear /// ^ (
      eval
    | (can \s* you \s*)? evaluate
  ) \s* (.*) $ ///i, (msg) ->
    try
      msg.reply "#{Vm.runInNewContext msg.match[2]}"
    catch err
      msg.reply "That don't make no sense!\n#{err}"