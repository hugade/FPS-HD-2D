extends Node3D

const SPEED = 80.0
var direction := Vector3.ZERO
var _traveled_distance := 0.0
const MAX_DISTANCE = 100.0
var bulletdmg = 1.0

@onready var area = $Area3D

func _ready():
	area.body_entered.connect(_on_body_entered)
	set_as_top_level(true)
	bulletdmg = get_node("/root/Node3D/Player").damage

func _physics_process(delta):
	if direction == Vector3.ZERO:
		return
	
	var step = direction * SPEED * delta
	position += step
	_traveled_distance += step.length()
	
	if _traveled_distance >= MAX_DISTANCE:
		queue_free()

func get_bullet_damage() -> float:
	return bulletdmg

func _on_body_entered(body):
	if body.is_in_group("enemigos"):
		if body.has_method("take_damage"):
			body.take_damage(get_bullet_damage())
		queue_free()

func _on_atkdmg_button_pressed() -> void:
	bulletdmg += 1
