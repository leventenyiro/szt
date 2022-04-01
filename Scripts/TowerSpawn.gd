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
## Signal showing a new turn has started
signal new_turn
## On click creates a tower on the tile that was clicked 
func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_pos = get_viewport().get_mouse_position()
		var tile_pos = map_to_world(world_to_map(mouse_pos))
		if event.button_index == BUTTON_LEFT:
			if get_cell(tile_pos.x, tile_pos.y) == -1 and grass.get_cell(tile_pos.x/16, tile_pos.y/16) == 0:
				var Tower_Instance = Tower.instance()
				Tower_Instance.set_position(Vector2(tile_pos.x,tile_pos.y))
				self.add_child(Tower_Instance)
				set_cell(tile_pos.x, tile_pos.y,0)
				grass.set_cell(tile_pos.x/16, tile_pos.y/16,-1)
				connect("new_turn", Tower_Instance, "_shoot")
				emit_signal("map_changed")
		if event.button_index == BUTTON_RIGHT:
			for item in self.get_children():
				if item.get_position() == tile_pos:
					set_cell(tile_pos.x, tile_pos.y,-1)
					grass.set_cell(tile_pos.x/16, tile_pos.y/16,0)
					item._destroy()
			emit_signal("map_changed")
			
func _on_Button3_pressed():
	emit_signal("new_turn")
