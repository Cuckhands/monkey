extends Area2D

@onready var timer: Timer = $Timer

var dart_ms: float = 1000.0
var damage: int = 1
var pierce: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called 60 times a second. 'delta' is the elapsed time since the previous tick.
func _physics_process(delta: float) -> void:
	if (!is_queued_for_deletion()):
		position += Vector2(dart_ms,0).rotated(rotation) * delta


func _on_area_entered(area: Area2D) -> void:
	area.hit(damage)
	pierce -= 1
	if pierce <= 0:
		queue_free()

# After the dart travels for the timer's length (1 second), it dies.
func _on_timer_timeout() -> void:
	queue_free()
