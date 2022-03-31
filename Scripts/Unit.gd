extends KinematicBody2D

signal healt_update(health)

export (int) var speed = 150
export (int) var max_health = 3

var nav = null setget set_nav
var path = []
var goal = Vector2()

onready var health = max_health setget _set_health

func damage(amount):
	_set_health(health - amount)

func kill():
	queue_free()

func _set_health(value):
	var prev_health = health;
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("healt_update",health)
		if health == 0:
			kill()
			
func set_nav(new_nav):
	nav = new_nav
	update_path()

func update_path():
	path = nav.get_simple_path(get_position(), goal, false)
	if path.size() == 0:
		queue_free()

func _physics_process(delta):
	if path.size() > 1:
		var d = get_position().distance_to(path[0])
		if d > 2:
			set_position(get_position().linear_interpolate(path[0], (speed * delta)/d))
		else:
			path.remove(0)
	else:
		queue_free()
		



