Fs   = require 'fs'
Path = require 'path'

class Builder

  # Setup a ready to go version of squire.
  #
  # path - A String directory to create/upgrade behaviours for.
  constructor: (@path) ->
    @behavioursDir = "#{__dirname}/behaviours"
    @skeletonDir   = "#{__dirname}/skeleton"

  # Copy the contents of a file from one place to another.
  #
  # from - A String source file to copy, must exist on disk.
  # to   - A String destination file to write to.
  #
  # Returns nothing.
  copy: (from, to) ->
    Fs.readFile from, 'utf8', (err, data) ->
      throw err if err?
      console.log "Copying #{Path.resolve from} -> #{Path.resolve to}"
      Fs.writeFileSync to, data, 'utf8'

  # Copy the default behaviours squire ships with to the behaviours folder.
  # This allows developers to easily remove behaviours squire defaults to if
  # they want. It also provides them with a few examples and a top level
  # behaviours folder.
  #
  # path - The destination.
  #
  # Returns nothing.
  copyDefaultBehaviours: (path) ->
    for file in Fs.readdirSync @behavioursDir
      @copy "#{@behavioursDir}/#{file}", "#{path}/#{file}"

  # Create the given `path` if it doesn't already exist.
  #
  # path - A String directory to ensure exists.
  #
  # Returns nothing.
  mkdirDashP: (path) ->
    Path.exists path, (exists) ->
      unless exists
        Fs.mkdir path, 0o0755, (err) ->
          throw err if err?

  # Public: Start the builder process.
  #
  # Setup a ready-to-deploy folder that uses the squire npm package,
  # overwriting basic squire files if they exist.
  #
  # Returns nothing.
  start: ->
    console.log "Creating a squire build at #{@path}"

    @mkdirDashP @path
    @mkdirDashP "#{@path}/behaviours"
    @mkdirDashP "#{@path}/bin"

    @copyDefaultBehaviours "#{@path}/behaviours"

    files = [
      'bin/squire'
      'bin/squire.cmd'
      '.gitignore'
      '.npmignore'
      'package.json'
      'README.md'
      'squire-behaviours.json'
    ]

    @copy "#{@skeletonDir}/#{file}", "#{@path}/#{file}" for file in files

module.exports = Builder