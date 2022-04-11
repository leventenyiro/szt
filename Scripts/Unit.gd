extends KinematicBody2D
signal healt_update(health)
export (int) var speed = 150
export (int) var max_health = 3
var nav = null setget set_nav
var path = []
var goal = Vector2()
onready var health = max_health setget _set_health, get_health
var player = null
onready var damage_to_castle = 1
var cost = 100
var drop_amount = 100
func _ready():
	$HealthBar.set_max(max_health)
	$HealthBar.visible=false
## The unit takes damage.
## @desc:
## 		The unit loses 'amount' amount of health.
func take_damage(amount):
	_set_health(health - amount)
	$HealthBar.value+=amount
	$HealthBar.visible=true
	
## Destroys the unit.
## @desc:
## 		Destroys the unit and gives gold to the player that destroyed it.
func kill():
	self.player.get_enemy().add_gold(self.drop_amount)
	var enemy_castle = weakref(self.player.get_enemy().get_castle())
	if enemy_castle.get_ref() and self.get_position() == enemy_castle.get_ref().get_position():
		enemy_castle.get_ref().take_damage(self.damage_to_castle)
	self.player.erase_unit(self)
	self.player.update_unit_count_label()
	queue_free()

## Set the unit's health.
## @desc:
## 		Set the unit's health to 'value' amount.
func _set_health(value):
	var prev_health = health;
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("healt_update",health)
		if health == 0:
			kill()

## Returns the unit's health.
## @desc:
## 		Return the unit's health.
func get_health():
	return health

## Set the unit's player.
## @desc:
## 		Set the unit's player.
func set_player(player):
	self.player = player
	
## Return the unit's player.
## @desc:
## 		Return the unit's player.
func get_player():
	return self.player
	
## Sets the unit's navigation.
## @desc:
## 		Sets the unit's navigation that helps it move on the shortest path, if no path exists the unit gets destroyed.
func set_nav(new_nav):
	nav = new_nav
	path = nav.get_simple_path(get_position(), goal, false)
	if path.size() == 0:
		kill()
	path=align(path)
	path.remove(0)
	
## Updates the unit's path.
## @desc:
## 		Updates the unit's path to current shortest path, if no path exists the unit gets destroyed.
func update_path():
	path = nav.get_simple_path(get_position(), goal, false)
	if path.size() == 0:
		kill()
	path=align(path)
	path.remove(0)

## Moves the unit.
## @desc:
## 		Moves the unit to the next tile on the shortest path, if no path exists the unit gets destroyed.
func move():
	path=align(path)
	if path.size() > 1:
		set_position(path[0])
		path.remove(0)
	else:
		kill()

## Aligns the path.
## @desc:
## 		Aligns the path to the tilemap's coordinates.
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

## Saves the unit's data.
## @desc:
## 		Saves the unit's health and position.
func save():
	var save_dict = {
		"health" : get_health(),
		"position.x" : get_position().x,
		"position.y" :get_position().y
	}
	return save_dict
	
