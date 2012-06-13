Builder                                 = require './src/builder'
Brain                                   = require './src/brain'
Squire                                  = require './src/squire'
Personality                             = require './src/personality'
Response                                = require './src/response'
{Listener, TextListener}                = require './src/listener'
{Message, TextMessage, CatchAllMessage} = require './src/message'

module.exports.summon = (personalityPath, personalityName, squireName) ->
  new Squire personalityPath, personalityName, squireName

module.exports.Builder         = Builder
module.exports.Brain           = Brain
module.exports.Squire          = Squire
module.exports.Personality     = Personality
module.exports.Response        = Response
module.exports.Listener        = Listener
module.exports.TextListener    = TextListener
module.exports.Message         = Message
module.exports.TextMessage     = TextMessage
module.exports.CatchAllMessage = CatchAllMessage