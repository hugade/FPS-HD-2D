extends CharacterBody3D

@export var speed = 2.0
var enemylife = 3.0
@onready var player = $"../CharacterBody3D"
@onready var bullet = "res://bala.tscn"
@onready var sprite = $Sprite_Enemigo

var originalcolor 
var hitcolor = Color(1, 0, 0)

func _ready():
	if sprite:
		originalcolor = sprite.modulate

func _process(_delta):
	var targetposition = Vector3(player.position.x, global_position.y, player.position.z)

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "bullet":
			sprite.modulet = hitcolor
			await get_tree().create_timer(0.2).timeout
			sprite.modulet = originalcolor
		
	
