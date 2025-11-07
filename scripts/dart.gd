extends Area2D

var dart_ms: float = 1000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called 60 times a second. 'delta' is the elapsed time since the previous tick.
func _physics_process(delta: float) -> void:
	if (!is_queued_for_deletion()):
		position += Vector2(dart_ms,0).rotated(rotation) * delta


func _on_area_entered(area: Area2D) -> void:
	area.hit()
	queue_free()
