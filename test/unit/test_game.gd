extends "res://addons/gut/test.gd"

var player1 = preload("res://Scripts/Player.gd").new()
var player2 = preload("res://Scripts/Player.gd").new()
var castle = preload("res://Scripts/Castle.gd").new()
var unit = preload("res://Scripts/Unit.gd").new()
var attack_unit = preload("res://Scripts/AttackUnit.gd").new()
var tower = preload("res://Scripts/Tower.gd").new()
var tower_unit = preload("res://Scripts/TowerUnit.gd").new()
var buy_panel = preload("res://Scripts/BuyPanel.gd").new()
var turn_queue = preload("res://Scripts/TurnQueue.gd").new()
var list_units = preload("res://Scripts/ListUnits.gd").new()

func test_player_append_tower():
	player1.towers = []
	assert_eq(player1.get_towers_size(), 0)
	player1.append_tower(tower)
	assert_eq(player1.get_towers_size(), 1)
	assert_eq(player1.towers[0], tower)

func test_player_append_unit():
	player1.units = []
	assert_eq(player1.get_units_size(), 0)
	player1.append_unit(unit)
	assert_eq(player1.get_units_size(), 1)
	assert_eq(player1.units[0], unit)

func test_player_remove_unit():
	player1.units = []
	player1.append_unit(unit)
	player1.remove_unit(0)
	assert_eq(player1.get_units_size(), 0)

func test_player_remove_unit_index_out_of_range():
	player1.units = []
	player1.remove_unit(1)
	assert_eq(player1.get_units_size(), 0)

func test_player_set_enemy():
	player1.set_enemy(player2)
	player2.set_enemy(player1)
	assert_eq(player1.get_enemy(), player2)
	assert_eq(player2.get_enemy(), player1)

func test_player_set_castle():
	player1.set_castle(castle)
	assert_not_null(player1.get_castle())

func test_player_set_castle_null():
	assert_null(player2.get_castle())

func test_player_get_unit():
	player1.units = []
	player1.append_unit(unit)
	assert_eq(player1.get_unit(0), unit)

func test_player_get_unit_null():
	player1.units = []
	assert_null(player1.get_unit(0))

func test_player_erase_unit():
	player1.units = []
	player1.append_unit(unit)
	player1.erase_unit(unit)
	assert_eq(player1.get_units_size(), 0)

func test_player_erase_unit_null():
	player1.units = []
	player1.erase_unit(attack_unit)
	assert_eq(player1.get_units_size(), 0)

func test_player_erase_tower():
	player1.towers = []
	player1.append_tower(tower)
	player1.erase_tower(tower)
	assert_eq(player1.get_towers_size(), 0)

func test_player_erase_tower_null():
	player1.towers = []
	player1.erase_tower(preload("res://Scripts/Tower.gd").new())
	assert_eq(player1.get_towers_size(), 0)

func test_unit_set_health():
	unit._set_health(100)
	assert_eq(unit.get_health(), 3)
	unit._set_health(3)
	assert_eq(unit.get_health(), 3)
	unit._set_health(2)
	assert_eq(unit.get_health(), 2)

func test_unit_set_player():
	unit.set_player(player1)
	assert_eq(unit.get_player(), player1)

func test_attack_unit_set_health():
	attack_unit._set_health(100)
	assert_eq(attack_unit.get_health(), 3)
	attack_unit._set_health(3)
	assert_eq(attack_unit.get_health(), 3)
	attack_unit._set_health(2)
	assert_eq(attack_unit.get_health(), 2)

func test_attack_unit_set_player():
	attack_unit.set_player(player1)
	assert_eq(attack_unit.get_player(), player1)

func test_tower_unit_set_health():
	tower_unit._set_health(100)
	assert_eq(tower_unit.get_health(), 3)
	tower_unit._set_health(3)
	assert_eq(tower_unit.get_health(), 3)
	tower_unit._set_health(2)
	assert_eq(tower_unit.get_health(), 2)

func test_tower_unit_set_player():
	tower_unit.set_player(player1)
	assert_eq(tower_unit.get_player(), player1)

func test_castle_set_health():
	castle._set_health(100)
	assert_eq(castle.get_health(), 10)
	castle._set_health(10)
	assert_eq(castle.get_health(), 10)
	castle._set_health(2)
	assert_eq(castle.get_health(), 2)

func test_castle_unit_set_player():
	castle.set_player(player1)
	assert_eq(castle.player, player1)

func test_tower_set_health():
	tower._set_health(100)
	assert_eq(tower.get_health(), 10)
	tower._set_health(10)
	assert_eq(tower.get_health(), 10)
	tower._set_health(2)
	assert_eq(tower.get_health(), 2)

func test_tower_set_player():
	tower.set_player(player1)
	assert_eq(tower.player, player1)

func test_tower_set_damage():
	tower._set_damage(10)
	assert_eq(tower.damage, 10)

func test_tower_set_cost():
	tower._set_cost(10)
	assert_eq(tower.cost, 10)

func test_tower_set_upgrade_cost():
	tower._set_upgrade_cost(10)
	assert_eq(tower.upgrade_cost, 10)

func test_buy_panel_get_mode():
	assert_eq(buy_panel.get_mode(), -1)

func test_turn_queue_current_player():
	turn_queue.current_player = player1
	assert_eq(turn_queue.get_current_player(), player1)

func test_turn_queue_end_button():
	watch_signals(turn_queue)
	turn_queue._on_EndTurnButton_pressed()
	assert_signal_emitted(turn_queue, 'turn_switched')

func test_list_units_buy_normal():
	watch_signals(list_units)
	list_units._on_ButtonBuyNormal_pressed()
	assert_signal_emitted(list_units, 'buy_simple_unit')

func test_list_units_buy_attacker():
	watch_signals(list_units)
	list_units._on_ButtonBuyAttacker_pressed()
	assert_signal_emitted(list_units, 'buy_attacker_unit')

func test_list_units_buy_tower():
	watch_signals(list_units)
	list_units._on_ButtonBuyTower_pressed()
	assert_signal_emitted(list_units, 'buy_tower_unit')
