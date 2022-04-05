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
		
	blue_player.set_enemy(red_player)
	red_player.set_enemy(blue_player)
	
	blue_castle_tile.set_cell(player1["castle"]["position.x"]/16, player1["castle"]["position.y"]/16, 0)
	var blue_castle = Castle.instance()
	blue_castle.set_position(Vector2(player1["castle"]["position.x"],player1["castle"]["position.y"]))
	blue_castle.get_child(0).texture = load('res://Map/blue_castle.png')
	blue_castle_tile.add_child(blue_castle)
	blue_castle._set_health(player1["castle"]["health"])
	blue_castle.set_player(blue_player)
	blue_player.set_castle(blue_castle)
	
	blue_player.set_gold(player1["gold"])
	for tower in player1["towers"]:
		tower_spawns.place_from_load(tower,blue_player,"blue")
	
	red_castle_tile.set_cell(player2["castle"]["position.x"]/16, player2["castle"]["position.y"]/16, 0)
	var red_castle = Castle.instance()
	red_castle.set_position(Vector2(player2["castle"]["position.x"], player2["castle"]["position.y"]))
	red_castle.get_child(0).texture = load('res://Map/red_castle.png')
	red_castle_tile.add_child(red_castle)
	red_castle._set_health(player2["castle"]["health"])
	red_castle.set_player(red_player)
	red_player.set_castle(red_castle)
	
	red_player.set_gold(player2["gold"])
	for tower in player2["towers"]:
		tower_spawns.place_from_load(tower,red_player,"red")
	
	blue_player.update_hp_label()
	red_player.update_hp_label()
	save_game.close()
	
	
