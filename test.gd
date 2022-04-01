extends TileMap

signal map_changed

onready var Tower =  preload("res://Scenes/Tower.tscn")
onready var env = get_node("/root/World/Environment")
onready var wat = get_node("/root/World/Water")
onready var tree = get_node("/root/World/Trees")
onready var roa = get_node("/root/World/Roads")
onready var tow = get_node("/root/World/Towers")
onready var grass = get_node("/root/World/Nav/Grass")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_pos = get_viewport().get_mouse_position()
		var tile_pos = map_to_world(world_to_map(mouse_pos))
		#print(mouse_pos)
		#print(tile_pos)
		tile_pos = tile_pos / 16
		set_cell(tile_pos.x,tile_pos.y,-1)
		env.set_cell(tile_pos.x,tile_pos.y,-1)
		wat.set_cell(tile_pos.x,tile_pos.y,-1)
		roa.set_cell(tile_pos.x,tile_pos.y,-1)
		tree.set_cell(tile_pos.x,tile_pos.y,-1)
		tow.set_cell(tile_pos.x,tile_pos.y,-1)
		grass.set_cell(tile_pos.x,tile_pos.y,-1)
	
