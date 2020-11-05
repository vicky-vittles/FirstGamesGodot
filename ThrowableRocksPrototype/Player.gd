extends KinematicBody2D

const TILE_SIZE = 32
const SCREEN_WIDTH = 1280
const MAX_ROCK_HORIZONTAL_DISTANCE = 0.45 * SCREEN_WIDTH
const MAX_ROCK_PRESS_TIME = 5
const MIN_ROCK_TRAVEL_TIME = 0.25
const MAX_ROCK_TRAVEL_TIME = 0.75
const FLOOR_NORMAL = Vector2(0, -1)

const WALK_SPEED = 2 * TILE_SIZE
const JUMP_HEIGHT = 1 * TILE_SIZE
const JUMP_TIME = 0.3

const GRAVITY = 2 * JUMP_HEIGHT / (JUMP_TIME * JUMP_TIME)
const JUMP_SPEED = -2 * JUMP_HEIGHT / JUMP_TIME

const ROCK = preload("res://Rock.tscn")
var player_height

var reached_rock_throw_max = false
var velocity = Vector2()


func _ready():
	player_height = TILE_SIZE/2 + abs($RockSpawn.position.y)


func _physics_process(delta):
	
	if Input.is_action_pressed("right"):
		velocity.x = WALK_SPEED
	elif Input.is_action_pressed("left"):
		velocity.x = -WALK_SPEED
	else:
		velocity.x = 0
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_SPEED
	
	if Input.is_action_pressed("throw"):
		
		if $RockThrowTimer.is_stopped() and not reached_rock_throw_max:
			$RockThrowTimer.start()
		
		var t = min($RockThrowTimer.wait_time - $RockThrowTimer.time_left, MAX_ROCK_PRESS_TIME)
		print(t)
		
		$RockThrowProgressBar.show()
		$RockThrowProgressBar.value = 100 * t / MAX_ROCK_PRESS_TIME
		
		if t == MAX_ROCK_PRESS_TIME:
			reached_rock_throw_max = true
			throw_rock(t)
	
	if Input.is_action_just_released("throw"):
		
		throw_rock($RockThrowTimer.wait_time - $RockThrowTimer.time_left)
		
		$RockThrowTimer.stop()
		$RockThrowProgressBar.hide()
	
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, FLOOR_NORMAL)

func throw_rock(t):
	var rock = ROCK.instance()
	rock.position = $RockSpawn.global_position
	rock.initialize(player_height, get_rock_horizontal_distance(t), get_rock_travel_time(t))
		
	$"../Rocks".add_child(rock)

func get_rock_horizontal_distance(t):
	return MAX_ROCK_HORIZONTAL_DISTANCE * t / MAX_ROCK_PRESS_TIME

func get_rock_travel_time(t):
	return MAX_ROCK_TRAVEL_TIME - (MAX_ROCK_TRAVEL_TIME - MIN_ROCK_TRAVEL_TIME) * t / MAX_ROCK_PRESS_TIME
