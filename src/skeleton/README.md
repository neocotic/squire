     ____                                       
    /\  _`\                   __                
    \ \,\L\_\     __   __  __/\_\  _ __    __   
     \/_\__ \   /'__`\/\ \/\ \/\ \/\`'__\/'__`\ 
       /\ \L\ \/\ \L\ \ \ \_\ \ \ \ \ \//\  __/ 
       \ `\____\ \___, \ \____/\ \_\ \_\\ \____\
        \/_____/\/___/\ \/___/  \/_/\/_/ \/____/
                     \ \_\                      
                      \/_/                      

This is a standalone version of GitHub's Campfire bot, [hubot][]. Much like its
predecessor, [squire][] is an extremely loyal and talented companion that
requires no configuration to get started with. The key difference from
[hubot][] is the context in which it runs. Unlike [hubot][], [squire][] doesn't
expect to be deployed in any environment and is quite happily run only from
shell.

## Play

You'll need to install the necessary dependencies for [squire][]. All of those
dependencies are provided by [npm][] and can be installed using;

``` bash
$ npm install
```

Once you've done that you can start playing with [squire][] immediately by
running the following in the terminal;

``` bash
$ bin/squire
```

Or, on Windows command prompt;

``` cmd
> .\bin\squire
```

Now you can begin interacting with [squire][] by typing `help`.

``` bash
Squire> help
age - Tells you the age of your Squire
date - Tells you todays date
dismiss - Dismisses your Squire
...
```

Feel free to look inside the `behaviours` directory for some examples. You can
delete any behaviours you don't want your [squire][] to have and add any that
you absolutely do.

If you want to enable logging while using your [squire][] you need to make sure
that the `SQUIRE_LOG_LEVEL` variable is set to the desired level;

``` bash
export SQUIRE_LOG_LEVEL="info"
```

## Memory

If you want your [squire's][squire] brain to remember things between uses you
can store its memories either in a file or on a running [redis][] service.

### File

In order to use the `brain-file.coffee` behaviour from the `squire-behaviours`
package you will probably want to set the `SQUIRE_BRAIN_PATH` variable to the
desired location for the `brain-dump.json` file;

``` bash
export SQUIRE_BRAIN_PATH="~/squire"
```

Otherwise, the default path used will be `$HOME/squire`. Although the file
does not need to exist already, it will not be created if the path does not
resolve to an existing directory.

This behaviour is enabled by default so just remove `brain-file.coffee` from
the `squire-behaviours.json` file and you don't have to worry about it.

### Redis

In order to use the `brain-redis.coffee` behaviour from the `squire-behaviours`
package you will probably want to either add the [Redis to Go][] addon on
[Heroku][] which requires a verified account;

``` bash
$ heroku config:add REDISTOGO_URL="..."
```
Or you can create an account at [Redis to Go][] and manually set the
`REDISTOGO_URL` variable;

``` bash
$ export REDISTOGO_URL="..."
```

Otherwise, it will attempt to make a connection to a locally running [Redis][]
service at `redis://localhost:6379`.

This behaviour is disabled by default but you can easily add it by adding
`brain-redis.coffee` tothe `squire-behaviours.json` file.

## Personalities

Personalities (or Adapters if you're familiar with [hubot][]) are the interface
to a service/environment you want your squire to play with. By default this is
simply the Shell terminal, but this can be anything really.

If you would like to run [squire][] outside of shell you will need to add the
personality package as a dependency to the `package.json` file under the
`dependencies` property.

Once you've added the dependency and ran `npm install` to install it you can
then run [squire][] with that personality using;

``` bash
$ bin/squire -p <personality>
```

Where `<personality>` is the name of your personality, without the `squire-`
prefix.

## squire-behaviours

If you stumble across a behaviour that you feel other [squires][squire] may
benefit from you can submit a pull request to the [squire-behaviours][]
repository instead of adding it to [squire][] itself.

To enable behaviours from the `squire-behaviours` package, add the behaviour
name (including the file extension) as a double quoted string to the
`squire-behaviours.json` file in this repository.

[heroku]: http://heroku.com
[hubot]: https://github.com/github/hubot
[npm]: http://npmjs.org
[redis]: http://redis.io
[redis to go]: https://redistogo.com
[squire]: http://neocotic.com/squire
[squire-behaviours]: https://github.com/neocotic/squire-behaviours