extends Node

@onready var path: Path2D = $Path2D
@onready var spawn_timer: Timer = $SpawnTimer

const FOLLOWER = preload("res://scenes/follower.tscn")
const ASTEROID = preload("res://scenes/asteroid.tscn")

var starting_pos: Vector2

func _ready() -> void:
	starting_pos = path.curve.get_point_position(0)

func _on_spawn_timer_timeout() -> void:
	var follower: PathFollow2D = FOLLOWER.instantiate()
	var asteroid: Asteroid = ASTEROID.instantiate()
	
	# We're choosing to decide speed at spawn time for some reason
	asteroid.move_speed = 200.0
	follower.position = starting_pos
	follower.add_child(asteroid)
	follower.asteroid = asteroid
	
	path.add_child(follower)
	
