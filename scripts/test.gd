extends Node

@onready var path: Path2D = $Path2D
@onready var spawn_timer: Timer = $SpawnTimer

const FOLLOWER = preload("res://scenes/follower.tscn")
const ASTEROID = preload("res://scenes/asteroid.tscn")

var debug_enabled = false

func _ready() -> void:
	pass

func _on_spawn_timer_timeout() -> void:
	var follower: PathFollow2D = FOLLOWER.instantiate()
	var asteroid: Asteroid = ASTEROID.instantiate()
	
	# We're choosing to decide speed at spawn time for some reason
	asteroid.move_speed = 200.0
	follower.add_child(asteroid)
	follower.asteroid = asteroid
	
	path.add_child(follower)

# Handles all remaining individual input events.
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"):
			debug_enabled = !debug_enabled
			print("TOGGLED DEBUG ", "ON" if debug_enabled else "OFF")
			emit_signal("debug_on")
