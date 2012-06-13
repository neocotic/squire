class Response

  # Public: Responses are sent to matching listeners. Messages know about the
  # content and user that made the original message, and how to reply back to
  # them.
  #
  # squire  - A Squire instance.
  # message - A Message instance.
  # match   - A Match object from the successful Regex match.
  constructor: (@squire, @message, @match) ->

  # Public: Request an answer to the given `question`.
  #
  # question - A String question.
  # secret   - Whether the input should be invisible.
  # callback - A Function that is triggered when the question is answered.
  #
  # Returns nothing.
  ask: (question, secret, callback) ->
    @squire.personality.ask question, secret, callback

  # Public: Tell the message to stop dispatching to listeners.
  #
  # Returns nothing.
  finish: ->
    @message.finish()

  # Public: Creates a scoped HTTP client with chainable methods for
  # modifying the request. This doesn't actually make a request though.
  # Once your request is assembled, you can call `get()`/`post()`/etc to
  # send the request.
  #
  # url - String URL to access.
  #
  # Returns a ScopedClient instance.
  http: (url) ->
    @squire.http url

  # Public: Picks a random item from the given `items`.
  #
  # items - An Array of items.
  #
  # Returns a random item.
  random: (items) ->
    items[Math.floor Math.random() * items.length]

  # Public: Posts a reply message.
  #
  # strings - One or more strings to be posted. The order of these strings
  #           should be kept intact.
  #
  # Returns nothing.
  reply: (strings...) ->
    @squire.personality.reply strings...

  # Public: Posts a message back.
  #
  # strings - One or more strings to be posted. The order of these strings
  #           should be kept intact.
  #
  # Returns nothing.
  send: (strings...) ->
    @squire.personality.send strings...

module.exports = Response