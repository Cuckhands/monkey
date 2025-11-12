## Base Monkey type
@abstract 
class_name Monkey extends Node2D
# TODO: Make this an @abstract class and create child monkeys that inherit it.

## Decides which target the monkey will choose
enum AttackPriority {
	## Traveled the furthest
	FIRST,
	## Traveled the least
	LAST, 
	## Closest to
	NEAREST,
	## Farthest from
	FARTHEST,
	## Highest current HP
	HEALTHIEST,
	## Lowest current HP
	WEAKEST,
	## First in, first out
	QUEUE,
	## First in, last out
	STACK,
}

# Swap them out for export so we can change them with each Monkey-type
@export var PROJECTILE: PackedScene = null
@export var hitbox: Area2D = null
@export var visual: Node2D = null
@export var attack_timer: Timer = null

## Self-explanatory
var current_priority := AttackPriority.NEAREST

var debug_enabled: bool = false
var debug: Dictionary = {
	"target_position": Vector2(0.0, 0.0)
}

func _init():
	print("Monkey Initialized")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer.stop()
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	hitbox.area_entered.connect(_on_vision_box_area_entered)
	hitbox.area_exited.connect(_on_vision_box_area_exited)
	


# Called 60 times a second. 'delta' is the elapsed time since the previous tick.
func _physics_process(_delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Should be used for rendering rather than physics and game-tick stuff.
func _process(_delta: float) -> void:
	pass


# Handles all remaining individual input events.
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug"):
			debug_enabled = !debug_enabled
			print("TOGGLED DEBUG ", "ON" if debug_enabled else "OFF")
			queue_redraw()


# This is the only place draw functions can be called.
func _draw() -> void:
	if debug_enabled:
		draw_circle(debug["target_position"], 6.0, Color.RED)


# This only recognizes when an object enters and is not a constant check.
func _on_vision_box_area_entered(_area: Area2D) -> void:
	if attack_timer.is_stopped():
		call_deferred("throw_projectile")


func _on_vision_box_area_exited(_area: Area2D) -> void:
	pass


## Rotates the monkey and spawns a projectile pointing at the asteroid
func throw() -> void:
	# Targets the area of the asteroid it intends to shoot
	var target_area: Area2D
	var areas: Array[Area2D] = hitbox.get_overlapping_areas()
	
	target_area = get_target_area(areas, current_priority)
	var target_position: Vector2 = target_area.global_position
	
	if (debug_enabled):
		debug["target_position"] = target_position - position
		queue_redraw()
	
	# Rotates the monkey
	visual.rotation += (visual.get_angle_to(target_position))
	
	# Creates the projectile and rotates it
	var projectile: Area2D = PROJECTILE.instantiate()
	
	# BUG: Something goes wrong here when the _area_entered calls this function
	# and the projectile gets thrown. It specifically calls out this line for changing
	# its state while "flushing queries".
	get_parent().add_child(projectile)
	projectile.rotate(visual.rotation)
	projectile.position = position
	
	attack_timer.start()

## Throws a projectile upon timer completion if there is at least one asteroid inside
func _on_attack_timer_timeout() -> void:
	if (hitbox.has_overlapping_areas()):
		throw()

## Takes in a list of areas and then returns one based on our AttackPriority
func get_target_area(areas: Array[Area2D], mode: AttackPriority) -> Area2D:
	match mode:
		AttackPriority.NEAREST:
			return get_nearest_area(areas)
		AttackPriority.FARTHEST:
			return get_farthest_area(areas)
	return null


# Make sure to keep the collision masks and collision layers updated for
# both monkeys and asteroids.
## Gets the asteroid nearest to the monkey.
func get_nearest_area(areas: Array[Area2D]) -> Area2D:
	var nearest_distance: float = INF
	var nearest_area: Area2D = null
	for area in areas:
		if global_position.distance_to(area.global_position) < nearest_distance:
			nearest_area = area
	return nearest_area

## Gets the asteroid farthest from the monkey.
func get_farthest_area(areas: Array[Area2D]) -> Area2D:
	var farthest_distance: float = -1.0
	var farthest_area: Area2D = null
	for area in areas:
		if global_position.distance_to(area.global_position) > farthest_distance:
			farthest_area = area
	return farthest_area
