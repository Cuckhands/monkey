extends Area2D
class_name Asteroid

@export var move_speed: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called 60 times a second. 'delta' is the elapsed time since the previous tick.
func _physics_process(_delta: float) -> void:
	pass

# TODO: We need to make it so that the balloon takes damage instead of just
# getting destroyed immediately from a hit. Alternatively, we literally
# treat this like bloons and a single hit can pop it, reducing it to a smaller
# sized asteroid, though maybe doing so would be bad for gameplay.
func hit() -> void:
	# BUG: This seems to break the game alongside the free from the follower code.
	# I've temporarily set it to just queue_free its parent (the follower) instead.
	# Though, this might just be the intended permanent solution.
	get_parent().queue_free()
