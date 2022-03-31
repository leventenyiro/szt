extends KinematicBody2D
## Signal showing the units health updated
signal healt_update(health)
## Speed value of the Unit.Can be changed in inspector
export (int) var speed = 150
## Health value of the Unit.Can be changed in inspector
export (int) var max_health = 3
## Navigation for the unit
var nav = null setget set_nav
## Shortest path to the goal
var path = []
## The goal that the unit's move toward
var goal = Vector2()
## Health value of the unit.
onready var health = max_health setget _set_health
## Unit loses "amount" health points
func take_damage(amount):
	_set_health(health - amount)
## Destroys the unit object
func kill():
	queue_free()
## Sets the unit's health to "value"
func _set_health(value):
	var prev_health = health;
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("healt_update",health)
		if health == 0:
			kill()
## Sets the nav and calculates the path
func set_nav(new_nav):
	nav = new_nav
	path = nav.get_simple_path(get_position(), goal, false)
	if path.size() == 0:
		queue_free()
	update_path()
## Moves the unit to the next tile in its path
func update_path():
	if path.size() > 1:
		if fmod(path[0].x, 16) == 0:
			path[0].x -= 8
		if fmod(path[0].y, 16) == 0:
			path[0].y -= 8
		set_position(path[0])
		path.remove(0)
	else:
		queue_free()
		
