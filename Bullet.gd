extends Area2D
class_name Bullet

var travelled_distance = 0
const RANGE = 1200
@export var SPEED = 1000
var damage = 20
@export var area2d : Area2D

func _ready():
	area2d.body_entered.connect(body_entered_area)

func set_damage(value : int):
	damage = value

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction*delta*SPEED
	travelled_distance += SPEED*delta
	if travelled_distance >= RANGE:
		queue_free()

func body_entered_area(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage(damage)
