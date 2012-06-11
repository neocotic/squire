class Message

  # Represents an incoming message.
  constructor: (@done = no) ->

  # Indicates that no other listener should be called on this object.
  #
  # Returns nothing.
  finish: ->
    @done = yes


class TextMessage extends Message

  # Represents an incoming text message.
  #
  # text - A String message.
  constructor: (@text) ->
    super()

  # Determines if the message matches the given `regex`.
  #
  # regex - A Regex to check.
  #
  # Returns a Match object or null.
  match: (regex) ->
    @text.match regex

class CatchAllMessage extends Message

  # Represents a message that no matchers matched.
  #
  # message - The original message.
  constructor: (@message) ->

module.exports.Message         = Message
module.exports.TextMessage     = TextMessage
module.exports.CatchAllMessage = CatchAllMessage