extends Node2D
class_name World

@export var player : Player
@export var ui : UI
@export var enemy_spawner: EnemySpawner
var weapon_container : WeaponContainer
var player_shooting : PlayerShooting

var player_score :int = 0

func _ready():
	if !player.player_damaged.is_connected(ui._on_player_damage):
		player.player_damaged.connect(ui._on_player_damage)
	if !player.enemy_killed.is_connected(ui._on_enemy_killed):
		player.enemy_killed.connect(ui._on_enemy_killed)
	weapon_container = player.weapon_container
	if !weapon_container.weapon_swap.is_connected(ui._on_weapon_swap):
		weapon_container.weapon_swap.connect((ui._on_weapon_swap))
	weapon_container._update_index(0)
	player_shooting = player.player_shooting
	if !player_shooting.update_ammo_count.is_connected((ui._update_ammo_count)):
		player_shooting.update_ammo_count.connect(ui._update_ammo_count)
	if !enemy_spawner.update_wave_info.is_connected(ui._on_update_wave_info):
		enemy_spawner.update_wave_info.connect(ui._on_update_wave_info)
