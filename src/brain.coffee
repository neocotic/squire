{EventEmitter} = require 'events'

class Brain extends EventEmitter

  # Represents somewhat persistent memory for the squire. Extend this.
  #
  # Returns a new Brain with no external memory.
  constructor: ->
    @memories = {}
    @resetMemoryLapse()

  # Public: Merge memories loaded from a datastore against those in this memory
  # representation.
  #
  # Returns nothing.
  #
  # Caveats: Deeply nested structures don't merge well.
  mergeMemories: (memories = {}) ->
    @memories[memory] = memories[memory] for memory of memories
    @emit 'remembered', @memories

  # Public: Emits the 'remember' event so that 'brain' behaviours can handle
  # persistence.
  #
  # Returns nothing.
  remember: ->
    @emit 'remember', @memories

  # Public: Reset the interval between `remember` function calls.
  #
  # seconds - An Integer of seconds between memory persistence.
  #
  # Returns nothing.
  resetMemoryLapse: (seconds = 5) ->
    clearInterval @memoryLapse if @memoryLapse
    @memoryLapse = setInterval =>
      @remember()
    , seconds * 1000

  # Public: Emits the 'stop' event so that 'brain' behaviours can handle it.
  #
  # Returns nothing.
  stop: ->
    clearInterval @memoryLapse
    @remember()
    @emit 'stop'

module.exports = Brain