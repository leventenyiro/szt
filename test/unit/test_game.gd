extends "res://addons/gut/test.gd"

var player1 = preload("res://Scripts/Player.gd").new()
var player2 = preload("res://Scripts/Player.gd").new()
var castle = preload("res://Scripts/Castle.gd").new()
var unit = preload("res://Scripts/Unit.gd").new()

func test_players_enemies():
	player1.set_enemy(player2)
	player2.set_enemy(player1)

	assert_eq(player1.get_enemy(), player2)
	assert_eq(player2.get_enemy(), player1)

func test_players_castle():
	player1.set_castle(castle)
	assert_not_null(player1.get_castle())
	assert_null(player2.get_castle())

func test_player_unit():
	player1.units = []
	assert_eq(player1.get_units_size(), 0)
	player1.append_unit(unit)
	assert_eq(player1.get_units_size(), 1)
	player1.erase_unit(unit)
	assert_eq(player1.get_units_size(), 0)
