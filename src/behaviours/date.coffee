# Description:
#   Teach Squire how to tell the date and time.
#
# Commands:
#   date - Tells you todays date
#   now - Tells you the current date and time
#   time - Tells you the current time

# Dependencies:
#   date-ext >= 1.0.2

require 'date-ext'

module.exports = (squire) ->

  formatDate = (date = new Date()) ->
    date.format 'l jS \\of F \\i\\n \\t\\h\\e \\y\\e\\a\\r Y'

  formatTime = (date = new Date()) ->
    hours = date.getHours()
    mins  = date.getMinutes()

    str   = if mins is 1
      '1 minute past '
    else if mins > 1
      "#{mins} minutes past "
    else
      ''

    str += "#{date.format 'g'} o'clock"
    str + if hours is 12
      ' at noon'
    else if hours is 0
      ' at midnight'
    else if 1 < hours < 12
      ' in the morning'
    else if 12 < hours < 17
      ' in the afternoon'
    else if hours >= 17
      ' in the evening'
    else
      ''

  squire.hear /// ^ (
        now
      | when (
            (\'?s | \s+ is) \s+ (it | this)
          | \s+ am \s+ i
          | \s+ are \s+ we
        )
    ) \?? $ ///i, (msg) ->
    msg.reply "It is #{formatDate()} at around #{formatTime()}."

  squire.hear /// ^ (
        date
      | (what(\'?s | \s+ is) | tell \s+ me)
        \s+ (today\'?s | the) \s+ date (\s+ today)?
      | what \s+ date \s+ is \s+ it
    ) \?? $ ///i, (msg) ->
    msg.reply "Today is #{formatDate()}."

  squire.hear /// ^ (
        time
      | (what(\'?s | \s+ is) | tell \s+ me)
        \s+ the \s+ ((current \s+)? time | time \s+ now)
      | what \s+ time \s+ is \s+ it
    ) \?? $ ///i, (msg) ->
    msg.reply "I reckon it's about #{formatTime()}."