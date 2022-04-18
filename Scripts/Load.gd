extends Node

onready var blue_castle_tile = get_node("/root/World/BlueCastle")
onready var red_castle_tile = get_node("/root/World/RedCastle")
onready var tower_spawns = get_node("/root/World/Towers")
onready var unit_spawns = get_node("/root/World/Nav")
onready var Castle =  preload("res://Scenes/Castle.tscn")
## Loads the seed .
## @desc:
## 		Loads the seed from the save file and returns it.
func get_seed():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.READ)
	var seeds = parse_json(save_game.get_line())
	save_game.close()
	return seeds["seed"]
## Loads the current player.
## @desc:
## 		Loads the current from the save file and returns it.
func get_current():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.READ)
	parse_json(save_game.get_line())
	var current = parse_json(save_game.get_line())
	var current_player
	return current["current_player"] 
## Loads the players
## @desc:
## 		Loads the players from the save file and sets them.
func get_player(blue_player,red_player):
	var save_game = File.new()
	save_game.open("user://savegame.save", File.READ)
	parse_json(save_game.get_line())
	parse_json(save_game.get_line())
	var player1 = parse_json(save_game.get_line())
	var player2 = parse_json(save_game.get_line())
		
	load_castle(blue_player,red_player,"blue",player1,blue_castle_tile)
	load_castle(red_player,blue_player,"red",player2,red_castle_tile)
	
	load_player(blue_player,"blue",player1)
	load_player(red_player,"red",player2)
	
	save_game.close()
## Loads the player's units and towers.
## @desc:
## 		Loads the player's units and towers and initializes them.
func load_player(player,color,data):	
	var type
	player.set_gold(data["gold"])
	for tower in data["towers"]:
		if tower["type"] == 0:
			type='S'
		if tower["type"] == 1:
			type='M'
		if tower["type"] == 2:
			type='L'
		tower_spawns.switch_current(type)
		tower_spawns.place_from_load(tower,player,color)
		
	for unit in data["units"]:
		unit_spawns.place_from_load(unit,player,color)
		
	player.update_hp_label()
## Loads the player's castle.
## @desc:
## 		Loads the player's castle and initializes it.
func load_castle(player,enemy,color,data,castle_tile):
	player.set_enemy(enemy)
		
	castle_tile.set_cell(data["castle"]["position.x"]/16, data["castle"]["position.y"]/16, 0)
	var castle = Castle.instance()
	castle.set_position(Vector2(data["castle"]["position.x"],data["castle"]["position.y"]))
	castle.get_child(0).texture = load(str('res://Map/',color,'_castle.png'))
	castle_tile.add_child(castle)
	castle._set_health(data["castle"]["health"])
	castle.set_player(player)
	player.set_castle(castle)
	
