extends Area2D
class_name Asteroid

## Emitted when the asteroid is destroyed
signal died

@onready var line_2d: Line2D = $Line2D

@export var move_speed: float = 0.0
@export var hp: int = 2

# This will be assigned by the game when spawned
var follower: PathFollow2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_color()

# Called 60 times a second. 'delta' is the elapsed time since the previous tick.
func _physics_process(_delta: float) -> void:
	pass

## Highlights the Asteroid when hovered
#func _on_mouse_entered() -> void:
	#line_2d.default_color = Color.LIME_GREEN
#func _on_mouse_exited() -> void:
	#line_2d.default_color = Color.WHITE

## Deals damage to the asteroid and kills it when the HP is reduced to <= 0
func hit(damage: int) -> void:
	hp -= damage
	if hp < 1:
		emit_signal("died")
		if !is_queued_for_deletion():
			queue_free()
		#get_parent().queue_free()
	update_color()

## Changes the color of the asteroid based on its health
func update_color() -> void:
	match(hp):
		1: line_2d.default_color = Color.WHITE
		2: line_2d.default_color = Color.LIME_GREEN
		3: line_2d.default_color = Color.ROYAL_BLUE
		4: line_2d.default_color = Color.ORANGE_RED
