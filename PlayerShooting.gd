extends Node2D
class_name PlayerShooting

@onready var bullet_spawn_point = %BulletSpawnPoint
@onready var weapon_sfx:PlayerWeaponSFX = %PlayerWeaponSFX

signal update_ammo_count(new_ammo_count:int)
const BULLET = preload("res://Scenes/Bullet.tscn")
const ROCKET = preload("res://Scenes/Rocket.tscn")
var current_weapon : WeaponContainer.WeaponStats = null
var next_fire :float = 0.0

func _process(delta):
	if current_weapon == null:
		return
	if next_fire > 0:
		next_fire -= delta
	if current_weapon.is_reloading:
		return
	if check_shoot_input():
		if next_fire <= 0.0 and current_weapon.cur_ammo > 0:
			shoot()
	if Input.is_action_just_pressed("reload"):
		start_reload(current_weapon)
	elif current_weapon.cur_ammo <= 0:
		start_reload(current_weapon)

func check_shoot_input() -> bool:
	if current_weapon.fire_mode == WeaponContainer.FireType.FULLAUTO:
		return Input.is_action_pressed("shoot")
	elif current_weapon.fire_mode == WeaponContainer.FireType.SEMIAUTO:
		return Input.is_action_just_pressed("shoot")
	else:
		return false

func shoot():
	for i in range(current_weapon.num_bullets):
		var new_bullet = instantiate_projectile()
		new_bullet.global_position = bullet_spawn_point.global_position
		var look_vec = get_global_mouse_position() - bullet_spawn_point.global_position
		new_bullet.global_rotation = atan2(look_vec.y, look_vec.x)
		new_bullet.set_damage(current_weapon.damage)
		if current_weapon.num_bullets > 1:
			var spread = -10.0 + randf()*20.0
			new_bullet.global_rotation += deg_to_rad(spread)
		bullet_spawn_point.add_child(new_bullet)
	next_fire = current_weapon.fire_delay
	current_weapon.cur_ammo -= 1
	update_ammo_count.emit(current_weapon.cur_ammo)
	weapon_sfx.play_shoot_sound(current_weapon.weapon_name)

func instantiate_projectile():
	if current_weapon.projectile_type == WeaponContainer.ProjectileType.BULLET:
		return BULLET.instantiate()
	if current_weapon.projectile_type == WeaponContainer.ProjectileType.ROCKET:
		return ROCKET.instantiate()

func start_reload(weapon : WeaponContainer.WeaponStats):
	weapon.is_reloading = true
	await get_tree().create_timer(current_weapon.reload_time).timeout
	weapon.is_reloading = false
	weapon.cur_ammo = weapon.magazine_size
	if weapon == current_weapon:
		update_ammo_count.emit(weapon.cur_ammo)

func _on_weapon_container_weapon_swap(weapon:WeaponContainer.WeaponStats):
	current_weapon = weapon
	next_fire = 0.0
