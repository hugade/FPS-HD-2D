extends CharacterBody3D

@export var speed = 2.0
@onready var player = $"../CharacterBody3D"

func _process(delta):
	var targetposition = Vector3(player.position.x, global_position.y, player.position.z)
	var targetdirection = (targetposition - global_position).normalized()

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
