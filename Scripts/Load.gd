extends Node

onready var blue_castle_tile = get_node("/root/World/BlueCastle")
onready var red_castle_tile = get_node("/root/World/RedCastle")
onready var tower_spawns = get_node("/root/World/Towers")
onready var Castle =  preload("res://Scenes/Castle.tscn")
func get_seed():
	var save_game = File.new()
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	var seeds = parse_json(save_game.get_line())
	save_game.close()
	return seeds["seed"]
func get_current():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.READ)
	parse_json(save_game.get_line())
	var current = parse_json(save_game.get_line())
	var current_player
	if current["current_player"] == 0:
		current_player = 1
	else:
		current_player = 0
	save_game.close()
	return current_player
func get_player(blue_player,red_player):
	var save_game = File.new()
	save_game.open("user://savegame.save", File.READ)
	parse_json(save_game.get_line())
	parse_json(save_game.get_line())
	var player1 = parse_json(save_game.get_line())
	var player2 = parse_json(save_game.get_line())
		
	load_player(blue_player,red_player,"blue",player1,blue_castle_tile)
	load_player(red_player,blue_player,"red",player2,red_castle_tile)
	
	save_game.close()
func load_player(player,enemy,color,data,castle_tile):
	player.set_enemy(enemy)
		
	castle_tile.set_cell(data["castle"]["position.x"]/16, data["castle"]["position.y"]/16, 0)
	var blue_castle = Castle.instance()
	blue_castle.set_position(Vector2(data["castle"]["position.x"],data["castle"]["position.y"]))
	blue_castle.get_child(0).texture = load(str('res://Map/',color,'_castle.png'))
	blue_castle_tile.add_child(blue_castle)
	blue_castle._set_health(data["castle"]["health"])
	blue_castle.set_player(player)
	player.set_castle(blue_castle)
	
	player.set_gold(data["gold"])
	for tower in data["towers"]:
		tower_spawns.place_from_load(tower,player,color)
		
	player.update_hp_label()
