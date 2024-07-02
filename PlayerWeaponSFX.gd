extends Node2D
class_name PlayerWeaponSFX

@export var smg_audio :AudioStreamPlayer2D
@export var rifle_audio:AudioStreamPlayer2D
@export var shotgun_audio :AudioStreamPlayer2D
@export var rl_audio :AudioStreamPlayer2D

var sound_dict = null

func _ready():
	sound_dict = {
		"SMG": smg_audio,
		"Rifle": rifle_audio,
		"Shotgun": shotgun_audio,
		"Rocket Launcher": rl_audio
	}
	
	
func play_shoot_sound(weapon_name : String):
	var audio_player :AudioStreamPlayer2D = sound_dict[weapon_name]
	audio_player.play()
