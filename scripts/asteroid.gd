extends Area2D
class_name Asteroid

signal death

@export var move_speed: float = 0.0
@export var hp: int = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called 60 times a second. 'delta' is the elapsed time since the previous tick.
func _physics_process(_delta: float) -> void:
	pass


func hit() -> void:
	# HP can be set to whatever tbr fr, kinda works. fixed the BUG where the 
	# thing kills everything cuz that wasnt good lmao
	hp -= 1
	if hp < 1:
		emit_signal("death")
		if !is_queued_for_deletion():
			queue_free()
		#get_parent().queue_free()
	
	
