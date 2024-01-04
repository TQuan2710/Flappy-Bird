extends CharacterBody2D

const GRAVITY : int = 1000
const MAX_LEVEL : int = 600
const SPEED : int = -500
var falling : bool = false
var flying : bool = false
const START_POS = Vector2i(100,400)

func _ready():
	reset()

func reset():
	falling = false
	flying = false
	position = START_POS
	set_rotation(0)

func flap():
	velocity.y = SPEED
	

func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_LEVEL:
			velocity.y = MAX_LEVEL
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			%AnimatedSprite2D.play()
		elif falling:
			set_rotation(PI)
			$AnimatedSprite2D.stop()
			move_and_collide(velocity * delta)
		else:
			$AnimatedSprite2D.stop()
