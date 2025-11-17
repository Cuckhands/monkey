## Base Monkey node, inherited by all Monkey types (Dart, Boomerang, etc...)
@abstract class_name Monkey extends Node2D

# Make sure to keep the collision masks and collision layers updated for all
# monkeys, asteroids, and projectiles.

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

# These are exported so we can change them within each Monkey-type
@export var PROJECTILE: PackedScene = null
@export var hitbox: Area2D = null
@export var visual: Node2D = null
@export var attack_timer: Timer = null
@export var base_attack_speed: float # Timer should be 1/base_attack_speed
@export var base_damage: int

## Self-explanatory
var current_priority := AttackPriority.FIRST

var is_debug_enabled: bool = false
var debug: Dictionary = {
	"target_position": Vector2(0.0, 0.0)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer.wait_time = 1.0 / base_attack_speed
	attack_timer.stop()
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	hitbox.area_entered.connect(_on_hitbox_area_entered)
	hitbox.area_exited.connect(_on_hitbox_area_exited)

# Called 60 times a second. 'delta' is the elapsed time since the previous tick.
func _physics_process(_delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Should be used for rendering rather than physics and game-tick stuff.
func _process(_delta: float) -> void:
	pass

# Handles all remaining individual input events.
func _unhandled_input(_event: InputEvent) -> void:
	pass

# This is the only place draw functions can be called.
func _draw() -> void:
	if is_debug_enabled:
		draw_circle(debug["target_position"], 6.0, Color.RED)

# This only recognizes when an object enters and is not a constant check.
func _on_hitbox_area_entered(_area: Area2D) -> void:
	if attack_timer.is_stopped():
		call_deferred("throw")

func _on_hitbox_area_exited(_area: Area2D) -> void:
	pass # Nothing yet

## Rotates the monkey and spawns a projectile pointing at the asteroid
func throw() -> void:
	# Indentifies which area (asteroid) it intends to shoot
	var target_area: Area2D
	var areas: Array[Area2D] = hitbox.get_overlapping_areas()
	target_area = get_target_area(areas, current_priority)
	# If no area is found, cancel the throw
	if !target_area: return
	var target_position: Vector2 = target_area.global_position
	
	if (is_debug_enabled):
		debug["target_position"] = target_position - position
		queue_redraw()
	
	# Rotates the monkey
	visual.rotation += (visual.get_angle_to(target_position))
	
	# Creates the projectile and rotates it
	var projectile: Area2D = PROJECTILE.instantiate()
	projectile.damage = base_damage
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
		AttackPriority.FIRST:
			return get_first_area(areas)
		AttackPriority.LAST:
			return get_last_area(areas)
		AttackPriority.HEALTHIEST:
			return get_healthiest_area(areas)
		AttackPriority.WEAKEST:
			return get_weakest_area(areas)
		_:
			return null

## Gets the asteroid nearest to the monkey.
func get_nearest_area(areas: Array[Area2D]) -> Area2D:
	var nearest_distance: float = INF
	var nearest_area: Area2D = null
	for area in areas:
		if global_position.distance_to(area.global_position) < nearest_distance:
			nearest_distance = global_position.distance_to(area.global_position)
			nearest_area = area
	return nearest_area

## Gets the asteroid farthest from the monkey.
func get_farthest_area(areas: Array[Area2D]) -> Area2D:
	var farthest_distance: float = -1.0
	var farthest_area: Area2D = null
	for area in areas:
		if global_position.distance_to(area.global_position) > farthest_distance:
			farthest_distance = global_position.distance_to(area.global_position)
			farthest_area = area
	return farthest_area

## Gets the asteroid with the highest progress following the path.
func get_first_area(areas: Array[Area2D]) -> Area2D:
	var highest_progress: float = -1.0
	var furthest_area: Area2D = null
	for area in areas:
		var follower_progress: float = area.follower.progress
		if follower_progress > highest_progress:
			highest_progress = follower_progress
			furthest_area = area
	return furthest_area

## Gets the asteroid with the lowest progress following the path.
func get_last_area(areas: Array[Area2D]) -> Area2D:
	var lowest_progress: float = INF
	var tardiest_area: Area2D = null
	for area in areas:
		var follower_progress: float = area.follower.progress
		if follower_progress < lowest_progress:
			lowest_progress = follower_progress
			tardiest_area = area
	return tardiest_area

## Gets the asteroid with the highest current health.
func get_healthiest_area(areas: Array[Area2D]) -> Area2D:
	var highest_hp: int = 0
	var healthiest_area: Area2D = null
	for area in areas:
		if (area.hp > highest_hp):
			highest_hp = area.hp
			healthiest_area = area
	return healthiest_area

## Gets the asteroid with the lowest current health.
func get_weakest_area(areas: Array[Area2D]) -> Area2D:
	var lowest_hp: int = (1 << 32) - 1 # 32-bit integer MAXIMUM
	var weakest_area: Area2D = null
	for area in areas:
		if (area.hp < lowest_hp): # Consider adding `&& area.hp > 0`
			lowest_hp = area.hp
			weakest_area = area
	return weakest_area
