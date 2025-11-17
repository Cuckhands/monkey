extends Node

@onready var path: Path2D = $Path2D
@onready var spawn_timer: Timer = $SpawnTimer

const FOLLOWER = preload("res://scenes/follower.tscn")
const ASTEROID = preload("res://scenes/asteroid.tscn")

var is_debug_enabled = false
var monkeys: Array[Monkey] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# TODO: This needs to be swapped out for a system that reads from a
# LinkedList that contains all of the asteroids that are supposed to be spawned
# this wave, a timer defining how long to wait before spawning the next one,
# a pointer to the next Link (obv), and a break point. Either we use one long
# LinkedList, or we use a special type of LinkedList that contains a reference
# to the spawn list that we clear separately plus a link to the "next wave".
# 
# Like this:
#	wave: SpawnList
#		- head: Link	#contains a reference to the current aster to be spawned
#		- next_wave: SpawnList	#contains a reference to the next spawn_list
#
#	head: AsterLink
#		- asteroid: Asteroid
#		- delay: float		# for use in the spawn timer
#		- next_aster: AsterLink		# will be set as new head as head is pulled
#
# This means that we will need to designed two subclasses of the regular SLL
# that either inherit from it or are actually just children of it directly. Idk
#
## Spawns an asteroid on the path with the given parameters
func _on_spawn_timer_timeout() -> void:
	var follower: PathFollow2D = FOLLOWER.instantiate()
	var asteroid: Asteroid = ASTEROID.instantiate()
	
	# We're choosing to decide params at spawn time for some reason
	asteroid.move_speed = 200.0
	asteroid.hp = randi_range(1, 4)
	follower.add_child(asteroid)
	# Gives them references to eachother. NOTE: This seems inefficient.
	follower.asteroid = asteroid
	asteroid.follower = follower
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
