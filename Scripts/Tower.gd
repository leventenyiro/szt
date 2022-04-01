extends Area2D

##
## Resposible for the tower's behavior
##
## @desc:
##     Enables the tower to shoot the first unit that is in it's range

## Damage value of the tower. Can be changed in inspector
export (float) var e_damage = 1;
onready var menu = get_node("/root/World/PopupMenu")
onready var area=get_node("/root/World/Towers")
## Damage value of the tower
onready var damage = e_damage
var _pos

## The tower shoots the furthest unit in its range 
func _shoot():
	var units = get_overlapping_bodies();
	if units.size()>0:
		units[0].take_damage(damage)
		print("I SHOT " + units[0].get_name())
func _destroy():
	#--Give player money here when its implemented
	queue_free()
func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_RIGHT:
		var mouse_pos = get_global_mouse_position()
		var tile_pos = area.map_to_world(area.world_to_map(mouse_pos))
		if tile_pos == get_position():
			menu._popup(self,tile_pos)


