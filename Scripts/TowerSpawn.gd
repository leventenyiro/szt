extends TileMap

onready var Tower =  preload("res://Scenes/Tower.tscn")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_pos = get_viewport().get_mouse_position()
		var tile_pos = map_to_world(world_to_map(mouse_pos))
		if get_cell(tile_pos.x, tile_pos.y) == -1:
			var Tower_Insatnce = Tower.instance()
			Tower_Insatnce.set_position(Vector2(tile_pos.x,tile_pos.y))
			self.add_child(Tower_Insatnce)
			set_cell(tile_pos.x, tile_pos.y,0)
			
