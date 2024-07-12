extends Node2D
class_name HealthComponent

@export var max_health:int
var cur_health :int

func _ready():
	cur_health = max_health
	
func take_damage(amount : int):
	if cur_health <= 0:
		return
	cur_health -= amount
	if cur_health <= 0:
		kill()
		
func kill():
	get_parent().queue_free()
