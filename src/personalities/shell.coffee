Readline      = require 'readline'

Personality   = require '../personality'
{TextMessage} = require '../message'

class Shell extends Personality

  ask: (question, callback) ->
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
      @repl.prompt()
      @receive new TextMessage buffer

    @emit 'ready'
    @repl.setPrompt "#{@squire.name}> "
    @repl.prompt()

exports.use = (squire) ->
  new Shell squire