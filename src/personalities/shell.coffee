Readline      = require 'readline'

Personality   = require '../personality'
{TextMessage} = require '../message'

class Shell extends Personality

  ask: (question, secret, callback) ->
    if 'function' is typeof secret
      callback = secret
      secret   = no

    if secret
      buffer    = ''
      listeners = @repl.input.listeners('keypress')[..]

      @repl.output.write "\n#{question} "

      @repl.input.removeAllListeners 'keypress'
      @repl.input.on 'keypress', (c, key) =>
        if key and 'enter' is key.name
          @repl.output.write '\n'
          @repl.input.removeAllListeners 'keypress'
          @repl.input.on 'keypress', listener for listener in listeners
          callback? buffer
          return

        if key and key.ctrl and 'c' is key.name
          @repl.output.write buffer
          process.exit 0

        @repl.output.write ''
        buffer += c
    else
      @repl.question "#{question} ", callback

  reply: (strings...) ->
    @send strings...
    @repl.prompt()

  send: (strings...) ->
    unless process.platform is 'win32'
      console.log "\x1b[01;32m#{str}\x1b[0m" for str in strings
    else
      console.log "#{str}" for str in strings

  start: ->
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
      @repl.close() if buffer.toLowerCase() is 'exit'
      @receive new TextMessage buffer

    @squire.catchAll (msg) =>
      @reply 'Huh?'

    @emit 'ready'
    @repl.setPrompt "#{@squire.name}> "
    @repl.prompt()

exports.use = (squire) ->
  new Shell squire