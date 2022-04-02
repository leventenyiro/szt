extends TileMap

##
## Resposible for the tower's placement
##
## @desc:
##     Creates a working tower on the tile the player has clicked

## Preloading the tower
signal map_changed
onready var Tower =  preload("res://Scenes/Tower.tscn")
onready var grass = get_node("/root/World/Nav/Grass")
onready var turn_queue = get_node('/root/World/GameLogic/TurnQueue')
## On click creates a tower on the tile that was clicked 
func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_pos = get_viewport().get_mouse_position()
		var tile_pos = map_to_world(world_to_map(mouse_pos))
		if event.button_index == BUTTON_LEFT:
			if get_cell(tile_pos.x, tile_pos.y) == -1 and grass.get_cell(tile_pos.x/16, tile_pos.y/16) == 0:
				var Tower_Instance = Tower.instance()
				var current_player = get_parent().get_node('GameLogic').get_child(0).get_current_player()
				if Tower_Instance.cost > current_player.gold:
					return
				Tower_Instance.get_child(0).texture = load(turn_queue.get_current_tower_asset_path())
				current_player.append_tower(Tower_Instance)
				Tower_Instance.set_player(current_player)
				Tower_Instance.set_position(Vector2(tile_pos.x,tile_pos.y))
				current_player.decrease_gold(Tower_Instance.cost)
				self.add_child(Tower_Instance)
				set_cell(tile_pos.x, tile_pos.y,0)
				grass.set_cell(tile_pos.x/16, tile_pos.y/16,-1)
				_map_changed()
	
func _remove(tile_pos,item):
	item._destroy()
	set_cell(tile_pos.x, tile_pos.y,-1)
	grass.set_cell(tile_pos.x/16, tile_pos.y/16,0)
	grass.update_bitmask_region(Vector2(0.0, 0.0),  Vector2(80,45))
	_map_changed()
	
func _new_turn():
	emit_signal("new_turn")
	
func _map_changed():
	emit_signal("map_changed")
