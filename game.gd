extends Node

@export var pipe_scene : PackedScene

var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED = 4
var screen_size : Vector2i
var pipes : Array
const PIPE_DELAY = 100
const PIPE_RANGE = 80
var ground_height : int

func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()	
	new_game()

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	pipes.clear()
	generate_pipe()
	$Bird.reset()

func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Bird.flying:
						$Bird.flap()
						check_top()

func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		if scroll > screen_size.x:
			scroll = 0
		$Ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED

func start_game():
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	$PiperTimer.start()

func _on_piper_timer_timeout():
	generate_pipe()

func generate_pipe():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	add_child(pipe)
	pipes.append(pipe)

func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = false
		stop_game()

func stop_game():
	$PiperTimer.stop()
	$Bird.flying = false
	game_running = false
	game_over = true

func bird_hit():
	$Bird.falling = true
	stop_game()
