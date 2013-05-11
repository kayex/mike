unless window?
  Vec2 = require("./Vec2.js").Vec2
  Spring = require("./Spring.js").Spring
  Particle = require("./Particle.js").Particle
else
  Vec2 = MIKE.Vec2
  Spring = MIKE.Spring
  Particle = MIKE.Particle

class Snake
  constructor: (position, color, @name) ->
    @dir = new Vec2(-1, 0)
    @move = false
    @left = false
    @right = false

    @iterations = 0

    # Options
    num = 10
    radius = 8
    springConst = 0.0004
    springLen = 3
    springFriction = 0.00005

    # Build snake
    @particles = []
    @springs = []

    # Particles
    pos = new Vec2(position.x, position.y)
    for i in [0.. num-1]
      rad = radius*(1-i/num)
      pos = pos.plus(new Vec2(springLen, 0))
      @particles.push(new Particle(pos, rad, color, new Vec2(0,0)))
    @particles[0].head = true
    @head = @particles[0]
    # Springs
    for i in [0.. num-2]
      @springs.push(new Spring(@particles[i], @particles[i+1], springConst, springLen, springFriction))

  render: (blending) ->
    for i in [@particles.length-1.. 0]
      @particles[i].render(blending)

    ctx.font = "15px Arial"
    ctx.fillStyle = "#fff"
    ctx.opa
    pos = @particles[0].currPos.plus(new Vec2(@name.split("").length * -3, -20))
    ctx.fillText(@name, pos.x, pos.y)

  update: (dt) ->
    for spring in @springs
      spring.solve()

    if not @move
      @dir = @particles[0].currPos.minus(@particles[2].currPos).unit()

    @dir.rotate(MIKE.Maths.toRadians(-0.5)) if @right and @move
    @dir.rotate(MIKE.Maths.toRadians(0.5)) if @left and @move
    @dir.rotate(MIKE.Maths.toRadians(Math.sin(@iterations+=0.04))) if @move
    @particles[0].vel.add(@dir.times_s(0.005)) if @move

    for particle in @particles
      particle.update(dt)

class BasicSnake
  # Snake skeleton for server-side usage
  constructor: (@initPos, @color, @name) ->
    @dir = new Vec2(-1, 0)
    @move = false
    @left = false
    @right = false

unless window?
  module.exports = exports
  exports.Snake = Snake
  exports.BasicSnake = BasicSnake
else
  MIKE.Snake = Snake
  MIKE.BasicSnake = BasicSnake