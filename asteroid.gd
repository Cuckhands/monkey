extends Area2D
class_name Asteroid

@export var move_speed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called 60 times a second. 'delta' is the elapsed time since the previous tick.
func _physics_process(_delta: float) -> void:
	pass

# BUG: This seems to break the game alongside the free from the follower code.
# I've temporarily set it to just queue_free its parent (the follower) instead.
func destroy() -> void:
	get_parent().queue_free()
