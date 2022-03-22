extends TileMap

##
## Resposible for the tower's placement
##
## @desc:
##     Creates a working tower on the tile the player has clicked

## Preloading the tower
onready var Tower =  preload("res://Scenes/Tower.tscn")
## Signal showing a new turn has started
signal new_turn
## On click creates a tower on the tile that was clicked 
func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_pos = get_viewport().get_mouse_position()
		var tile_pos = map_to_world(world_to_map(mouse_pos))
		if get_cell(tile_pos.x, tile_pos.y) == -1:
			var Tower_Insatnce = Tower.instance()
			Tower_Insatnce.set_position(Vector2(tile_pos.x,tile_pos.y))
			self.add_child(Tower_Insatnce)
			set_cell(tile_pos.x, tile_pos.y,0)
			connect("new_turn", Tower_Insatnce, "_shoot")
## Emits a new turn signal 
func _on_Button_pressed():
	emit_signal("new_turn")
