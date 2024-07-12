extends Node2D
class_name EnemySpawner

@onready var player : Player = %Player

signal update_wave_info(text:String)

var num_waves = 5
var zombies_per_wave = 50
var seconds_between_waves = 60
var min_dist_spawn = 1000
var max_dist_spawn = 1500
var group_delay = 3.0

var is_wave_ongoing = false
var time_until_wave:float = 0.0

var cur_wave = 1

var enemies_killed :int = 0


const ZOMBIE = preload("res://Scenes/Zombie.tscn")

func _ready():
	is_wave_ongoing = false
	time_until_wave = 5.99
	cur_wave = 1
	enemies_killed = 0
	if !player.enemy_killed.is_connected(player_killed_enemy):
		player.enemy_killed.connect(player_killed_enemy)
	
func _process(delta):
	if !is_wave_ongoing:
		if time_until_wave <= 0:
			is_wave_ongoing = true
			await spawn_wave()
			return
		time_until_wave -= delta
		var new_text = "Wave {} starts in: {}s".format([cur_wave,int(clamp(time_until_wave,0,1000))], "{}")
		update_wave_info.emit(new_text)
		return
	

func spawn_wave():
	enemies_killed = 0
	var new_text = "Wave {}!".format([cur_wave], "{}")
	update_wave_info.emit(new_text)
	var zombies_spawned = 0
	while zombies_spawned < zombies_per_wave:
		zombies_spawned += await spawn_group(zombies_spawned)
		await get_tree().create_timer(group_delay).timeout
	while enemies_killed < zombies_per_wave:
		await get_tree().create_timer(0.15).timeout
	is_wave_ongoing = false
	time_until_wave = 10.99
	cur_wave += 1
	increase_wave_difficulty()
	
func spawn_group(spawned_count:int) -> int:
	var spawn_count = 3 + int(randf()*5)
	for i in range(spawn_count):
		if (i+1) + spawned_count > zombies_per_wave:
			break
		var dist_fromplayer = int(min_dist_spawn + (max_dist_spawn-min_dist_spawn)*randf())
		var spawn_pos = Vector2(dist_fromplayer, 0)
		spawn_pos = spawn_pos.rotated(deg_to_rad(randf()*360))
		var new_zombie :Zombie = ZOMBIE.instantiate()
		new_zombie.global_position = player.global_position + spawn_pos
		new_zombie.set_player(player)
		add_child(new_zombie)
		await get_tree().create_timer(0.25).timeout
	return spawn_count
	
func player_killed_enemy(_score :int):
	enemies_killed += 1
	print(enemies_killed)

func increase_wave_difficulty():
	zombies_per_wave *= 2
	group_delay -= 0.5*group_delay
	if group_delay <= 0.5:
		group_delay = 0.5
