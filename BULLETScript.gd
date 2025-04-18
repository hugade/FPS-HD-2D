extends Node3D

const bulletspeed = 40.0

@onready var mesh = $mesh
@onready var ray = $RayCast3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -bulletspeed) * delta
	if ray.is_colliding():
		queue_free()
