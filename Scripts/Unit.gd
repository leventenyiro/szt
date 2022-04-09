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
onready var health = max_health setget _set_health, get_health
var player = null
onready var damage_to_castle = 1
var cost = 100
var drop_amount = 100
## Unit loses "amount" health points
func take_damage(amount):
	_set_health(health - amount)
## Destroys the unit object
func kill():
	self.player.get_enemy().add_gold(self.drop_amount)
	var enemy_castle = weakref(self.player.get_enemy().get_castle())
	if enemy_castle.get_ref() and self.get_position() == enemy_castle.get_ref().get_position():
		enemy_castle.get_ref().take_damage(self.damage_to_castle)
	self.player.erase_unit(self)
	self.player.update_unit_count_label()
	queue_free()

## Sets the unit's health to "value"
func _set_health(value):
	var prev_health = health;
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("healt_update",health)
		if health == 0:
			kill()
func get_health():
	return health
func set_player(player):
	self.player = player
func get_player():
	return self.player
## Sets the nav and calculates the path
func set_nav(new_nav):
	nav = new_nav
	path = nav.get_simple_path(get_position(), goal, false)
	if path.size() == 0:
		kill()
	path=align(path)
	path.remove(0)
	
## Moves the unit to the next tile in its path
func update_path():
	path = nav.get_simple_path(get_position(), goal, false)
	if path.size() == 0:
		kill()
	path=align(path)
	path.remove(0)
func move():
	path=align(path)
	if path.size() > 1:
		set_position(path[0])
		path.remove(0)
	else:
		kill()
	
	
func align(paths):
	var new_paths = []
	var pre
	for item in paths:
		if fmod(item.x, 16) != 0:
			item.x -= 8
		if fmod(item.y, 16) != 0:
			item.y -= 8
		new_paths.append(Vector2(item))
	if(new_paths.size()>2):
		pre=new_paths[0]
		if(pre==new_paths[1]):
			if(new_paths[1].x-16==new_paths[2].x):
				new_paths[1].x-=16
			if(new_paths[1].y-16==new_paths[2].y):
				new_paths[1].y-=16
	return new_paths
func save():
	var save_dict = {
		"health" : get_health(),
		"position.x" : get_position().x,
		"position.y" :get_position().y
	}
	return save_dict
	
