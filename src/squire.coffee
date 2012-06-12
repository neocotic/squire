Fs         = require 'fs'
HttpClient = require 'scoped-http-client'
Log        = require 'log'
Path       = require 'path'
Url        = require 'url'

Brain                          = require './brain'
Response                       = require './response'
{Listener, TextListener}       = require './listener'
{TextMessage, CatchAllMessage} = require './message'

DEFAULT_PERSONALITIES = ['shell']

class Squire

  # Squires receive messages and dispatch them to matching listeners.
  #
  # personalityPath - A String of the path to local personalities.
  # personality     - A String of the personality name.
  # name            - A String of the squire name, defaults to Squire.
  constructor: (personalityPath, personality, name = 'Squire') ->
    @name        = name
    @brain       = new Brain
    @alias       = false
    @personality = null
    @commands    = []
    @listeners   = []
    @loadPaths   = []

    if process.env.SQUIRE_LOG_LEVEL?
      @logger = new Log process.env.SQUIRE_LOG_LEVEL
    else
      noop = ->
      @logger =
        alert: noop
        critical: noop
        debug: noop
        emergency: noop
        error: noop
        info: noop
        notice: noop
        read: noop
        warning: noop

    @buildVersion()
    @loadPersonality personalityPath, personality if personality?

  # Private: Load help information from a loaded behaviour.
  #
  # path - A String path to the resource on disk.
  # callback - An optional Function that is called with the extracted help.
  #
  # Returns nothing.
  buildHelp: (path, callback) ->
    Fs.readFile path, 'utf-8', (err, body) =>
      if err?
        if callback? then callback err else throw err

      results = for i, line of body.split '\n'
        break    unless line[0] is '#' or line.substr(0, 2) is '//'
        continue unless line.match '-'
        line[2..line.length]

      @commands.push results...
      callback? null, results

  # Public: The version of Squire from npm.
  #
  # Returns a String of the version number.
  buildVersion: ->
    package_path = "#{__dirname}/../package.json"

    content = JSON.parse Fs.readFileSync package_path, 'utf8'
    @version = content.version

  # Public: Adds a Listener that triggers when no other text matchers match.
  #
  # callback - A Function that is called with a Response object.
  #
  # Returns nothing.
  catchAll: (callback) ->
    @listeners.push new Listener @, (msg) ->
      msg instanceof Squire.CatchAllMessage
    , (msg) ->
      msg.message = msg.message.message
      callback msg

  # Public: Dismiss your loyal squire and gracefully stop its processes.
  #
  # Returns nothing.
  dismiss: ->
    @personality.stop()
    @brain.stop()

  # Public: Adds a Listener that attempts to match incoming messages based on
  # the given `regex`.
  #
  # regex    - A Regex that determines if `callback` should be called.
  # callback - A Function that is called with a Response object.
  #
  # Returns nothing.
  hear: (regex, callback) ->
    @listeners.push new TextListener @, regex, callback

  # Public: Help commands for running behaviours.
  #
  # Returns an Array of help commands for running behaviours.
  helpCommands: ->
    @commands.sort()

  # Public: Creates a scoped HTTP client with chainable methods for
  # modifying the request. This doesn't actually make a request though.
  # Once your request is assembled, you can call `get()`/`post()`/etc to
  # send the request.
  #
  # url - String URL to access.
  #
  # Examples:
  #
  #     res.http('http://example.com')
  #       # Set a single header
  #       .header('Authorization', 'foo bar')
  #
  #       # Set multiple headers
  #       .headers(Authorization: 'bearer abcdef', Accept: 'application/json')
  #
  #       # Add URI query parameters
  #       .query(a: 1, b: 'foo & bar')
  #
  #       # Make the actual request
  #       .get() (err, res, body) ->
  #         console.log body
  #
  #       # Or, you can POST data
  #       .post(data) (err, res, body) ->
  #         console.log body
  #
  # Returns a ScopedClient instance.
  http: (url) ->
    HttpClient.create url

  # Public: Loads all behaviours from the given `path`.
  #
  # path - A String path on the file system.
  #
  # Returns nothing.
  load: (path) ->
    @logger.debug "Loading behaviours from #{path}"

    Path.exists path, (exists) =>
      if exists
        @loadPaths.push path
        for resource in Fs.readdirSync path
          @loadResource path, resource

  # Public: Load behaviours specfic in the `squire-behaviours.json` resource.
  #
  # path       - A String path to the squire-behaviours resources.
  # behaviours - An Array of behaviours to load.
  #
  # Returns nothing.
  loadBehaviours: (path, behaviours) ->
    @logger.debug "Loading behaviours from #{path}"

    @loadResource path, behaviour for behaviour in behaviours

  # Load the personality Squire is going to use.
  #
  # path        - A String of the path to `personality` if local.
  # personality - A String of the personality name to use.
  #
  # Returns nothing.
  loadPersonality: (path, personality) ->
    @logger.debug "Loading personality #{personality}"

    try
      path = if personality in DEFAULT_PERSONALITIES
        "#{path}/#{personality}"
      else
        "squire-#{personality}"

      @personality = require("#{path}").use @
    catch err
      @logger.error "Cannot load personality #{personality} - #{err}\n#{err.stack}"

  # Public: Loads the given `resource` in `path`.
  #
  # path - A String path on the file system.
  # file - A String file name in `path` on the file system.
  #
  # Returns nothing.
  loadResource: (path, resource) ->
    ext  = Path.extname resource
    full = Path.join path, Path.basename resource, ext

    if ext in ['.coffee', '.js']
      try
        require(full) @
        @buildHelp "#{path}/#{resource}"
      catch err
        @logger.error "#{err}"

  # Public: A helper reply Function which delegates to the personality's reply
  # Function.
  #
  # strings - One or more Strings for each message to send.
  #
  # Returns nothing.
  reply: (strings...) ->
    @personality.reply strings...

  # Public: Passes the given `message` to any interested Listeners.
  #
  # message - A Message instance. Listeners can flag this message as 'done' to
  #           prevent further execution.
  #
  # Returns nothing.
  receive: (message) ->
    results = []
    for listener in @listeners
      try
        results.push listener.call message
        break if message.done
      catch err
        @logger.error "Unable to call the listener: #{err}"
        false
    if message not instanceof Squire.CatchAllMessage and true not in results
      @receive new Squire.CatchAllMessage message

  # Public: Adds a Listener that attempts to match incoming messages directed
  # at the squire based on the given `regex`. All regexes treat patterns like
  # they begin with a '^'
  #
  # regex    - A Regex that determines if `callback` should be called.
  # callback - A Function that is called with a Response object.
  #
  # Returns nothing.
  respond: (regex, callback) ->
    re = regex.toString().split '/'
    re.shift()
    modifiers = re.pop()

    if re[0] and re[0][0] is '^'
      @logger.warning "Anchors don't work well with respond, perhaps you want to use 'hear'"
      @logger.warning "The regex in question was #{regex.toString()}"

    pattern = re.join '/'

    if @alias
      alias = @alias.replace /[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&'
      newRegex = new RegExp "^(?:#{alias}[:,]?|#{@name}[:,]?)\\s*(?:#{pattern})", modifiers
    else
      newRegex = new RegExp "^#{@name}[:,]?\\s*(?:#{pattern})", modifiers

    @logger.debug newRegex.toString()
    @listeners.push new TextListener @, newRegex, callback

  # Public: A helper send Function which delegates to the personality's send
  # Function.
  #
  # strings - One or more Strings for each message to send.
  #
  # Returns nothing.
  send: (strings...) ->
    @personality.send strings...

  # Public: Summon your little squire and start the event loop for the
  # personality.
  #
  # Returns nothing.
  summon: ->
    @personality.start()

module.exports = Squire