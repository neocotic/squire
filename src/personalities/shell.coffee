Colors        = require 'colors'
Readline      = require 'readline'

Personality   = require '../personality'
{TextMessage} = require '../message'

class Shell extends Personality

  ask: (question, callback) ->
    if @_questionCallback
      @repl.prompt()
    else
      @repl.setPrompt "#{question} "
      @_questionCallback = callback
      @repl.prompt()

  reply: (strings...) ->
    @send strings..., ''
    @repl.prompt()

  send: (strings...) ->
    unless process.platform is 'win32'
      console.log "\x1b[01;32m#{str}\x1b[0m" for str in strings
    else
      console.log "#{str}" for str in strings

  start: ->
    prompt = "#{@squire.name}> "
    stdin  = process.openStdin()
    stdout = process.stdout

    process.on 'uncaughtException', (err) =>
      @squire.logger.error "#{err}"

    @repl = Readline.createInterface stdin, stdout, null

    @repl.on 'close', =>
      stdin.destroy()
      @squire.dismiss()
      process.exit 0

    @repl.on 'line', (buffer) =>
      if @_questionCallback
        callback = @_questionCallback
        @_questionCallback = null
        @repl.setPrompt prompt
        callback buffer
      else
        @repl.close() if buffer.toLowerCase() is 'exit'
        @receive new TextMessage buffer

    @squire.catchAll (msg) =>
      @reply 'Huh?'

    @emit 'ready'
    @repl.setPrompt prompt
    @repl.prompt()

exports.use = (squire) ->
  new Shell squire