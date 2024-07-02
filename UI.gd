extends CanvasLayer
class_name UI

@onready var health_label: Label = $Control/MarginContainer/VBoxContainer/HBoxContainer/HealthLabel
@onready var score_label : Label = $Control/MarginContainer/VBoxContainer/HBoxContainer2/ScoreLabel
@onready var ammo_label : Label = $Control/MarginContainer/VBoxContainer2/HBoxContainer/AmmoDisplay
@onready var weapon_label : Label = $Control/MarginContainer/VBoxContainer2/HBoxContainer2/WeaponName
@onready var wave_label : Label = $Control/MarginContainer/VBoxWaveInfo/HBoxContainer/WaveInfoLabel
@onready var fps_label : Label = $Control/MarginContainer/VBoxContainer/HBoxContainer/FPSLabel

var player_score = 0

func _ready():
	player_score = 0
	_update_score_label(player_score)
	var fps_timer := Timer.new()
	add_child(fps_timer)
	fps_timer.connect("timeout", _on_FPSTimer_timeout)
	fps_timer.start()

func _on_FPSTimer_timeout() -> void:
	fps_label.text = str(Engine.get_frames_per_second())

func _update_health_label(value:int):
	if value < 0:
		value = 0
	health_label.text = "Health: "+str(value)

func _update_score_label(value:int):
	score_label.text = "Score: "+str(value)

func _on_player_damage(health_value: int):
	_update_health_label(health_value)
	
func _on_enemy_killed(score:int):
	player_score += score
	_update_score_label(player_score)
	
func _on_weapon_swap(new_weapon:WeaponContainer.WeaponStats):
	weapon_label.text = new_weapon.weapon_name
	ammo_label.text = str(new_weapon.cur_ammo)
	
func _update_ammo_count(ammo : int):
	ammo_label.text = str(ammo)

func _on_update_wave_info(text: String):
	wave_label.text = text
