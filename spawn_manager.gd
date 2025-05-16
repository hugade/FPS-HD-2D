extends Node3D

@export var enemyscene: PackedScene
@onready var poslimit = $"../PositiveLimit"
@onready var neglimit = $"../NegativeLimit"
@onready var enemyspawntimer = $"../EnemySpawnTimer"
var spawncooldown = 2.0
var spawnenemies = 1
var enemydmg = 2
var enemyspd = 2.0
var enemylife = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemyspawntimer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
	for i in range(spawnenemies):
		var newenemy = enemyscene.instantiate()
		add_child(newenemy)
		newenemy.global_position = Vector3(
			randf_range(neglimit.position.x, poslimit.position.x),
			0.0,
			randf_range(neglimit.position.z, poslimit.position.z)
		)
	

func _enemy_lvl_up():
	spawncooldown = min(0.5, spawncooldown - 0.2)
	spawnenemies = max(5.0, spawnenemies + 1)
	enemylife += 1
	enemydmg = max(20.0, enemydmg + 1)
	enemyspd = max(6.0, enemyspd + 0.5)
