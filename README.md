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

Since the archtecture of this repository is pretty much identical to that of
[hubot][] **you'll *still* probably never have to hack on this repo directly.**

Instead this repository provides a library that's distributed by `npm` that you
simply require in your project. Follow the instructions below and prepare your
[squire][] ready for action.

## Recruiting your own

Make sure you have [node][] and [npm][] (npm comes with node v0.6.5+)
installed.

Download the [latest version of squire][downloads].

Then follow the instructions in the [README][] in the extracted `squire`
directory.

## Personalities

Personalities (or Adapters if you're familiar with [hubot][]) are the interface
to a service/environment you want your squire to play with. By default this is
simply the Shell terminal, but this can be anything really.

Please submit issues and pull requests for third party personalities to the
personality repository instead of this repository unless it's the Shell
personality.

## squire-behaviours

[Squire][] comes with a number of default behaviours (i.e. scripts), but
there's a growing number of extras in the [squire-behaviours][] repository.
`squire-behaviours` is a way to share behaviours with the entire community.

Check out the [README][squire-behaviours-readme] for more help on installing
individual behaviours.

[downloads]: https://github.com/neocotic/squire/downloads
[hubot]: https://github.com/github/hubot
[node]: http://nodejs.org
[npm]: http://npmjs.org
[readme]: https://github.com/neocotic/squire/blob/master/src/skeleton/README.md
[squire]: http://neocotic.com/squire
[squire-behaviours]: https://github.com/neocotic/squire-behaviours
[squire-behaviours-readme]: https://github.com/neocotic/squire-behaviours#readme