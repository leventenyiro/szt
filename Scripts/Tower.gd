extends Area2D

##
## Resposible for the tower's behavior
##
## @desc:
##     Enables the tower to shoot the first unit that is in it's range

## Damage value of the tower. Can be changed in inspector
export (float) var e_damage;
export (int) var type;
onready var menu = get_node("/root/World/PopupMenu")
onready var area = get_node("/root/World/Towers")
onready var grass = get_node('/root/World/Nav/Grass')
onready var road = get_node('/root/World/Roads')
onready var line = get_node('Line2D')
signal healt_update(health)
export (int) var max_health = 10
onready var health = max_health setget _set_health, get_health
## Damage value of the tower
onready var damage = e_damage
onready var player
var cost = 300
var refund = cost/2
var upgrade_cost=200 


func _ready():
	print(type)
	$HealthBar.set_max(max_health)

## The unit takes damage.
## @desc:
## 		The unit loses 'amount' amount of health.
func take_damage(damage):
	_set_health(health - damage)
	$HealthBar.value+=damage

## Set the towers's health.
## @desc:
## 		Set the towers's health to 'value' amount.
func _set_health(value):
	var prev_health = health;
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("healt_update",health)
		if health == 0:
			_destroy()

## Returns the unit's health.
## @desc:
## 		Return the unit's health.
func get_health():
	return health
	
## The tower shoots an enemy unit.
## @desc:
## 		The tower shoots the furthest enemy unit in its range.
func shoot():
	line.visible = false
	line.clear_points()
	var units = get_overlapping_bodies();
	var enemy_units = []
	for unit in units:
		if self.player.units.find(unit) == -1 and !unit.is_in_group("NO"):
			enemy_units.append(unit)
	if enemy_units.size()>0:
		enemy_units[0].take_damage(damage)
		line.add_point(Vector2(8,8))
		line.add_point(enemy_units[0].get_position()-(self.get_position()-Vector2(8,8)))
		line.visible = true
		print("I SHOT " + enemy_units[0].get_name())
		print(enemy_units[0].get_health())
		
## Destroys the tower.
## @desc:
## 		 Destroys the tower and refunds half the gold invested in it.
func _destroy():
	refund=cost/2
	player.add_gold(refund)
	self.player.erase_tower(self)
	grass.set_cell(self.get_position().x/16, self.get_position().y/16, 0)
	road.set_cell(self.get_position().x/16, self.get_position().y/16, 0)
	var map_size = Vector2(1280,720)
	road.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
	grass.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
	queue_free()
	
## Upgrades the tower's damage.
## @desc:
## 		 Upgrades the tower's damage by 1, each upgrade increases the cost by 100 gold.
func _upgrade():
	if upgrade_cost > player.gold:
		return
	player.decrease_gold(upgrade_cost)
	damage+=1
	cost+=upgrade_cost
	upgrade_cost+=100

## Shows the tower's range and menu.
## @desc:
## 		 Shows the tower's range and menu when clicked on.
func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		get_children()[2].visible=false
		if event.button_index == BUTTON_RIGHT:
			var mouse_pos = get_global_mouse_position()
			var tile_pos = area.map_to_world(area.world_to_map(mouse_pos))
			if tile_pos == get_position():
				menu._popup(self,tile_pos)
				get_children()[2].visible=true

## Sets the tower's player.
## @desc:
## 		Sets the tower's player.
func set_player(player):
	self.player = player

## Sets the tower's damage.
## @desc:
## 		Sets the tower's damage to "damage" amount.
func _set_damage(damage):
	self.damage = damage
	
## Sets the tower's cost.
## @desc:
## 		Sets the tower's cost to "cost" amount.
func _set_cost(cost):
	self.cost = cost

## Sets the tower's upgrade cost.
## @desc:
## 		Sets the tower's upgrade cost to "upgrade_cost" amount.
func _set_upgrade_cost(upgrade_cost):
	self.upgrade_cost = upgrade_cost

## Saves the tower's data.
## @desc:
## 		Saves the tower's cost,upgrade cost,damage and position.
func save():
	var save_dict = {
		"cost" : cost,
		"upgrade_cost" : upgrade_cost,
		"damage" : damage,
		"type" : self.type,
		"position.x" : get_position().x,
		"position.y" :get_position().y
	}
	return save_dict
