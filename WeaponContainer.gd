extends Node2D
class_name WeaponContainer

enum FireType {SEMIAUTO, FULLAUTO, CONTINUOUS}
enum ProjectileType {BULLET, ROCKET, GRENADE, FIRE}

var my_weapons : Array[WeaponStats]
var selected_index:int

signal weapon_swap(weapon : WeaponStats)

func _ready():
	init_weapons()
	selected_index = 0
	
func init_weapons():
	my_weapons = []
	my_weapons.append(WeaponStats.create_weapon("SMG", 25, 20, 1.3, 0.075, FireType.FULLAUTO, ProjectileType.BULLET, 1))
	my_weapons.append(WeaponStats.create_weapon("Rifle", 105, 10, 2.1, 0.4, FireType.SEMIAUTO, ProjectileType.BULLET, 1))
	my_weapons.append(WeaponStats.create_weapon("Shotgun", 18, 8, 2.5, 0.35, FireType.SEMIAUTO, ProjectileType.BULLET, 8))
	my_weapons.append(WeaponStats.create_weapon("Rocket Launcher", 250, 3, 3.0, 0.2, FireType.SEMIAUTO, ProjectileType.ROCKET, 1))

func _process(_delta):
	var new_index:int = -1
	if Input.is_action_just_pressed("weapon_1"):
		new_index = 0
	elif Input.is_action_just_pressed("weapon_2"):
		new_index = 1
	elif Input.is_action_just_pressed("weapon_3"):
		new_index = 2
	elif Input.is_action_just_pressed("weapon_4"):
		new_index = 3
	else:
		return
	if new_index != selected_index:
		_update_index(new_index)
	
func _update_index(index:int):
	selected_index = index
	weapon_swap.emit(my_weapons[selected_index])

class WeaponStats:
	var weapon_name : String
	var damage : int
	var magazine_size : int
	var reload_time : float
	var fire_delay : float
	var fire_mode : FireType
	var projectile_type : ProjectileType
	var num_bullets : int
	var is_reloading : bool
	var cur_ammo : int
	
	static func create_weapon(title:String, dmg:int, ammo:int, reload:float, delay:float, mode:FireType, projectile:ProjectileType, bullets : int) -> WeaponStats:
		var weapon = WeaponStats.new()
		weapon.weapon_name = title
		weapon.damage = dmg
		weapon.magazine_size = ammo
		weapon.reload_time = reload
		weapon.fire_delay = delay
		weapon.fire_mode = mode
		weapon.projectile_type = projectile
		weapon.num_bullets = bullets
		weapon.is_reloading = false
		weapon.cur_ammo = weapon.magazine_size
		return weapon
		
