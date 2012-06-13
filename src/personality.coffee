{EventEmitter}  = require 'events'

class Personality extends EventEmitter

  # A personality is a specific interface for squires.
  #
  # squire - A Squire instance.
  constructor: (@squire) ->

  # Public: Raw method for building a question and sending it back. Extend
  # this.
  #
  # question - A String question.
  # secret   - Whether the input should be invisible.
  # callback - A Function that is triggered when the question is answered.
  #
  # Returns nothing.
  ask: (question, secret, callback) ->
    callback = secret if 'function' is typeof secret
    callback?()

  # Public: Creates a scoped HTTP client with chainable methods for modifying
  # the request. This doesn't actually make a request though.
  # Once your request is assembled, you can call `get()`/`post()`/etc to
  # send the request.
  #
  # url - String URL to access.
  #
  # Returns a ScopedClient instance.
  http: (url) ->
    @squire.http url

  # Public: Dispatch a received message to the squire.
  #
  # message - A Message instance.
  #
  # Returns nothing.
  receive: (message) ->
    @squire.receive message

  # Public: Raw method for building a reply and sending it back. Extend this.
  #
  # strings - One or more Strings for each reply to send.
  #
  # Returns nothing.
  reply: (strings...) ->

  # Public: Raw method for sending data back. Extend this.
  #
  # strings - One or more Strings for each message to send.
  #
  # Returns nothing.
  send: ->

  # Public: Raw method for invoking the squire to start. Extend this.
  #
  # Returns nothing.
  start: ->

  # Public: Raw method for stopping the squire. Extend this.
  #
  # Returns nothing.
  stop: ->
    @squire.brain.stop()

module.exports = Personality