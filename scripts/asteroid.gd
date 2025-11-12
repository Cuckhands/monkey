extends Area2D
class_name Asteroid

## Emitted when the asteroid is destroyed
signal died

@onready var line_2d: Line2D = $Line2D

@export var move_speed: float = 0.0
@export var hp: int = 2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_2d.default_color = Color.WHITE


# Called 60 times a second. 'delta' is the elapsed time since the previous tick.
func _physics_process(_delta: float) -> void:
	pass

# Highlights the Asteroid when hovered
func _on_mouse_entered() -> void:
	line_2d.default_color = Color.LIME_GREEN
func _on_mouse_exited() -> void:
	line_2d.default_color = Color.WHITE

func hit(damage: int) -> void:
	# HP can be set to whatever tbr fr, kinda works. fixed the BUG where the 
	# thing kills everything cuz that wasnt good lmao
	hp -= damage
	if hp < 1:
		emit_signal("died")
		if !is_queued_for_deletion():
			queue_free()
		#get_parent().queue_free()
	
	
