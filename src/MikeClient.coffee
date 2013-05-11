unless window?
  Snake = require("./Snake.js").Snake
  BasicSnake = require("./Snake.js").BasicSnake
else
  Snake = MIKE.Snake
  BasicSnake = MIKE.BasicSnake

class MikeClient
  constructor: (@connection) ->
    @connection.on "message", (msg) =>
      @emit "message", (msg)

    @connection.on "close", (code, reason) =>
      @emit "disconnect"

  sendInvite: (color) ->
    @connection.transmit MS.serialize({
      type: TYPES.INV,
      color: color
    })

  sendUpdate: (state) ->
    # Send update of own state

  addSnake: (snake) ->
    if snake instanceof BasicSnake or snake instanceof Snake
      @snake = snake
    else
      throw "Illegal snake of type #{typeof snake}"