extends Node3D

var deadenemies
var totaldeadenemies
var upgrade = false
var atkdmglvl = 0
var atkspdlvl = 0

@onready var totaldeadenemiestxt = $"../Canvas/Layout/TotalDeadEnemiesTXT"
@onready var upgradescreen = $"../Canvas/UpgradeScreen"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	atkdmglvl = 0.0
	atkspdlvl = 0.0
	deadenemies = 0.0
	totaldeadenemies = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if deadenemies >= 10.0:
		upgrade = true
		get_node("/root/Node3D/SpawnManager")._enemy_lvl_up()
		deadenemies = 0.0
	if upgrade == true:
		upgradescreen.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
	totaldeadenemiestxt.text = str(totaldeadenemies)

func _lvlupatkdmg():
	atkdmglvl += 1
	upgradescreen.visible = false
	upgrade = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused

func _lvlupatkspd():
	atkspdlvl += 1
	upgradescreen.visible = false
	upgrade = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false

func _on_atkspd_button_pressed() -> void:
	_lvlupatkspd()

func _on_atkdmg_button_pressed() -> void:
	_lvlupatkspd()
