extends Node

@onready var path: Path2D = $Path2D
@onready var spawn_timer: Timer = $SpawnTimer

const FOLLOWER = preload("res://scenes/follower.tscn")
const ASTEROID = preload("res://scenes/asteroid.tscn")

var is_debug_enabled = false
var monkeys: Array[Monkey] = []

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
			is_debug_enabled = !is_debug_enabled
			print("TOGGLED DEBUG ", "ON" if is_debug_enabled else "OFF")
			for monkey in monkeys:
				monkey.is_debug_enabled = is_debug_enabled
				monkey.queue_redraw()


func _on_child_entered_tree(node: Node) -> void:
	if node is Monkey:
		monkeys.append(node)
		print("Added a monkey: ", node)

func _on_child_exiting_tree(node: Node) -> void:
	# This code has not been tested. Expect bugs.
	if node is Monkey:
		monkeys.erase(node)
		print("Removed a monkey: ", node)
