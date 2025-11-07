extends PathFollow2D

@export var asteroid: Asteroid = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called 60 times a second. 'delta' is the elapsed time since the previous tick.
func _physics_process(delta: float) -> void:
	# Moves the asteroid down the line
	progress += asteroid.move_speed * delta
	
	if progress_ratio >= 1.0:
		print("An asteroid reached the end!")
		asteroid.queue_free()
		queue_free()
