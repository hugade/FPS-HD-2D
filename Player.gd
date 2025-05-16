extends CharacterBody3D


const SPEED = 7.0
const JUMP_VELOCITY = 6.0
const SENSITIVITY = 0.003

var damage = 1.0

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var gun_anim = $Head/Camera3D/Gun

var bullet = load("res://bala.tscn")
var instance
var life = 20

@onready var bulletpos = $Head/Camera3D/BULLETPOS
@onready var raycast = $Head/Camera3D/RayCast3D
@onready var cooldowntimer = $ShootCoolDown
@onready var lifetxt = $"../Canvas/Layout/VidaTXT"

var can_take_damage = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cooldowntimer.wait_time = 1.0
	$Detector.connect("area_entered", Callable(self, "_on_enemy_detected"))
	gun_anim.play("idle")

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction : Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED,delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * SPEED,delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED,delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED,delta * 3.0)
		
	move_and_slide()
	
	lifetxt.text = str(life)
	
	if Input.is_action_pressed("fire") and cooldowntimer.is_stopped():
		_shoot()
		cooldowntimer.start()

func _shoot():
	gun_anim.play("disparo")
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = bulletpos.global_position
	new_bullet.rotation = Vector3(camera.rotation.x, head.rotation.y, 0.0)
	if raycast.is_colliding():
		var hit_point = raycast.get_collision_point()
		new_bullet.direction = (hit_point - bulletpos.global_position).normalized()
	else:
		new_bullet.direction = -bulletpos.global_transform.basis.z.normalized()
	get_parent().add_child(new_bullet)

func _on_atkspd_button_pressed() -> void:
	cooldowntimer.wait_time = max(0.1, cooldowntimer.wait_time - 0.2)

func _on_atkdmg_button_pressed() -> void:
	damage += 1

func take_damage(damageamount: float):
	life -= damageamount

func _on_enemy_detected(area):
	if can_take_damage and area.is_in_group("enemigos"):
		if area.has_method("get_enemy_dmg"):
			take_damage(area.get_enemy_dmg())
			can_take_damage = false
			await get_tree().create_timer(1.0).timeout
			can_take_damage = true
