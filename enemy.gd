extends CharacterBody3D

var speed
var enemylife
var enemydmg
@onready var player = Node3D
@onready var sprite = $Sprite_Enemigo
@onready var bulletdmg

var originalcolor 
var hitcolor = Color(1, 0, 0)

func _ready():
	if sprite:
		originalcolor = sprite.modulate
	player = get_tree().get_first_node_in_group("player")
	speed = get_node("/root/Node3D/SpawnManager").enemyspd
	enemylife = get_node("/root/Node3D/SpawnManager").enemylife
	enemydmg = get_node("/root/Node3D/SpawnManager").enemydmg

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
   
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if is_instance_valid(collider) and collider.is_in_group("balas"):
			if collider.has_method("get_bullet_damage"):
				take_damage(collider.get_bullet_damage())

func take_damage(damageamount: float):
	enemylife -= damageamount
	sprite.modulate = hitcolor
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = originalcolor
	if enemylife <= 0:
		get_node("/root/Node3D/UpgradeManager").deadenemies += 1
		get_node("/root/Node3D/UpgradeManager").totaldeadenemies += 1
		queue_free()

func get_enemy_dmg() -> float:
	return enemydmg

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(get_enemy_dmg())
