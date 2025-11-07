extends Node2D

@onready var vision_box: Area2D = $VisionBox
@onready var attack_timer: Timer = $AttackTimer
const DART = preload("res://scenes/dart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer.stop()


# Called 60 times a second. 'delta' is the elapsed time since the previous tick.
func _physics_process(_delta: float) -> void:
	pass


# This only recognizes when an object enters and is not a constant check.
func _on_vision_box_area_entered(_area: Area2D) -> void:
	if attack_timer.is_stopped():
		throw_dart()

func _on_vision_box_area_exited(_area: Area2D) -> void:
	pass


## Spawns a projectile moving in the direction of the asteroid
## Also rotates the monkey
func throw_dart() -> void:
	# GETS ASTEROID NEAREST TO THE MONKEY
	var nearest_distance: float = INF
	var nearest_area: Area2D = null
	var areas: Array[Area2D] = vision_box.get_overlapping_areas()
	for area in areas:
		if position.distance_to(area.global_position) < nearest_distance:
			nearest_area = area
	
	# Rotates the monkey
	rotation += get_angle_to(nearest_area.global_position)
	
	# Creates the dart and rotates it
	var dart = DART.instantiate()
	
	# BUG: Something goes wrong here when the _area_entered calls this function
	# and the dart gets thrown. It specifically calls out this line for changing
	# its state while "flushing queries".
	get_parent().add_child(dart)
	dart.rotate(rotation)
	dart.position = position
	
	attack_timer.start()

## Throws a dart upon timer completion if there is at least one asteroid inside
func _on_attack_timer_timeout() -> void:
	if (vision_box.has_overlapping_areas()):
		throw_dart()
