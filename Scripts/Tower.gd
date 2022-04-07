extends Area2D

##
## Resposible for the tower's behavior
##
## @desc:
##     Enables the tower to shoot the first unit that is in it's range

## Damage value of the tower. Can be changed in inspector
export (float) var e_damage;
onready var menu = get_node("/root/World/PopupMenu")
onready var area = get_node("/root/World/Towers")
## Damage value of the tower
onready var damage = e_damage
onready var player
var cost = 300
var refund = cost/2
var upgrade_cost=200 
## The tower shoots the furthest unit in its range 
func shoot():
	var units = get_overlapping_bodies();
	var enemy_units = []
	for unit in units:
		if self.player.units.find(unit) == -1:
			enemy_units.append(unit)
	if enemy_units.size()>0:
		enemy_units[0].take_damage(damage)
		print("I SHOT " + enemy_units[0].get_name())
func _destroy():
	refund=cost/2
	player.add_gold(refund)
	queue_free()
func _upgrade():
	if upgrade_cost > player.gold:
		return
	player.decrease_gold(upgrade_cost)
	damage+=1
	cost+=upgrade_cost
	upgrade_cost+=100
func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		get_children()[2].visible=false
		if event.button_index == BUTTON_RIGHT:
			var mouse_pos = get_global_mouse_position()
			var tile_pos = area.map_to_world(area.world_to_map(mouse_pos))
			if tile_pos == get_position():
				menu._popup(self,tile_pos)
				get_children()[2].visible=true

func set_player(player):
	self.player = player
func _set_damage(damage):
	self.damage = damage
func _set_cost(cost):
	self.cost = cost
func _set_upgrade_cost(upgrade_cost):
	self.upgrade_cost = upgrade_cost
func save():
	var save_dict = {
		"cost" : cost,
		"upgrade_cost" : upgrade_cost,
		"damage" : damage,
		"position.x" : get_position().x,
		"position.y" :get_position().y
	}
	return save_dict
