{TextMessage} = require './message'
Response      = require './response'

class Listener

  # Listeners receive every message and decide if they want to act on it.
  #
  # squire   - A Squire instance.
  # matcher  - A Function that determines if this listener should trigger the
  #            callback.
  # callback - A Function that is triggered if the incoming message matches.
  constructor: (@squire, @matcher, @callback) ->

  # Public: Determines if the listener likes the content of the message. If
  # so, a Response built from the given `message` is passed to the Listener
  # callback.
  #
  # message - A Message instance.
  #
  # Returns a boolean of whether the matcher matched.
  call: (message) ->
    if match = @matcher message
      @callback new Response @squire, message, match
      true
    else
      false

class TextListener extends Listener

  # TextListeners receive every text message and decide if they want to act on
  # it.
  #
  # squire   - A Squire instance.
  # regex    - A Regex that determines if this listener should trigger the
  #            callback.
  # callback - A Function that is triggered if the incoming message matches.
  constructor: (@squire, @regex, @callback) ->
    @matcher = (message) =>
      message.match @regex if message instanceof TextMessage

module.exports.Listener     = Listener
module.exports.TextListener = TextListener