extends Navigation2D
## Signal showing the map has updated
signal map_changed
signal simulation_phase_start
signal simulation_phase_end
## Preloading the unit
var unit = preload("res://Scenes/Unit.tscn")
var attack_unit = preload("res://Scenes/AttackUnit.tscn")
var tower_unit = preload("res://Scenes/TowerUnit.tscn")
## Plane where the units navigate
onready var nav = self

onready var turn_queue = get_node('../GameLogic/TurnQueue')
onready var end_turn = get_node('/root/World/CanvasLayer/UI/Popup/VBoxContainer/HBoxContainer3/HBoxContainer2/EndTurn')
onready var simulate_button = get_node('/root/World/CanvasLayer/UI/Popup/VBoxContainer/HBoxContainer3/HBoxContainer2/Simulate')
onready var buy_units = get_node('/root/World/CanvasLayer/UI/Popup/VBoxContainer/HBoxContainer3/HBoxContainer/Button')
onready var buy_towers = get_node('/root/World/CanvasLayer/UI/Popup/VBoxContainer/HBoxContainer3/HBoxContainer/Button2')
onready var popup = get_node('/root/World/CanvasLayer/UI/Popup')

func _ready():
	set_process_input(true)
	connect("simulation_phase_start", self, 'disable_all')
	connect("simulation_phase_end", self, 'enable_all')

## Buys a unit.
## @desc:
## 		Buys a unit for the current player.
func buy_simple_unit():
	var current_player = turn_queue.current_player
	initialize_unit(current_player, 0)
	
func buy_attacker_unit():
	var current_player = turn_queue.current_player
	initialize_unit(current_player, 1)

func buy_tower_unit():
	var current_player = turn_queue.current_player
	initialize_unit(current_player, 2)

## Updates the map.
## @desc:
## 		Updates the map if any changes happened.
func _on_Towers_map_changed():
	var current_player = turn_queue.current_player
	emit_signal("map_changed")

## Initializes a unit.
## @desc:
## 		 Initializes a unit for the current player.
func initialize_unit(current_player, type):
	var unit_instance
	if type == 0:
		unit_instance = unit.instance()
	if type == 1:
		unit_instance = attack_unit.instance()
	if type == 2:
		unit_instance = tower_unit.instance()
	print(unit_instance)
	if unit_instance.cost > current_player.gold:
		return
	unit_instance.set_player(current_player)
	unit_instance.set_position(current_player.get_castle().get_position())
	set_goal(unit_instance, current_player)
	unit_instance.nav = nav
	unit_instance.get_child(0).texture = load(turn_queue.get_current_unit_asset_path(type))
	add_child(unit_instance)
	current_player.decrease_gold(unit_instance.cost)
	connect("map_changed", unit_instance, "update_path")
	current_player.append_unit(unit_instance)
	current_player.update_unit_count_label()
	current_player.update_units_count_same_tile_label()

static func set_goal(unit_instance, current_player):
	if unit_instance.type == 0:
		unit_instance.goal = current_player.get_enemy().get_castle().get_position()
		return
	if unit_instance.type == 1:
		var closest = current_player.get_enemy().closest_to_point(unit_instance.get_position())
		if closest:
			unit_instance.goal = closest.get_position()
		else:
			unit_instance.goal = current_player.get_enemy().get_castle().get_position()
		return
	if unit_instance.type == 2:
		var closest = current_player.get_enemy().closest_tower_to_point(unit_instance.get_position())
		if closest:
			unit_instance.goal = closest.get_position()
		else:
			unit_instance.goal = current_player.get_enemy().get_castle().get_position()
		return
	
## Loads the unit.
## @desc:
## 		Loads the unit's data and initializes it.
func place_from_load(unit_dic,current_player,color):	
	var unit_instance
	var texture
	if unit_dic["type"] == 0:
		unit_instance = unit.instance()
		texture = str('res://Map/',color,'_troop_castle.png')
	if  unit_dic["type"] == 1:
		unit_instance = attack_unit.instance()
		texture = str('res://Map/',color,'_troop_troop.png')
	if  unit_dic["type"] == 2:
		unit_instance = tower_unit.instance()
		texture = str('res://Map/',color,'_troop_tower.png')
	print(unit_instance)
	unit_instance.set_player(current_player)
	unit_instance.set_position(Vector2(unit_dic["position.x"],unit_dic["position.y"]))
	set_goal(unit_instance, current_player)
	unit_instance.nav = nav
	unit_instance.get_child(0).texture = load(texture)
	add_child(unit_instance)
	connect("map_changed", unit_instance, "update_path")
	current_player.append_unit(unit_instance)
	current_player.update_unit_count_label()
	current_player.update_units_count_same_tile_label()

## Simulates a turn.
## @desc:
## 		Simulates a turn where all units move one tile and all towers shoot once.
func _on_SimulateButton_pressed():
	emit_signal('simulation_phase_start')
	if self.popup.get_mode() == 1:
		self.popup._on_Button2_pressed()
	if self.popup.get_mode() == 0:
		self.popup._on_Button_pressed()	
	for x in range(turn_queue.blue_player.get_units_size()):
		var current_unit = turn_queue.blue_player.get_unit(x)
		if current_unit != null:
			current_unit.move()
	for x in range(turn_queue.red_player.get_units_size()):
		var current_unit = turn_queue.red_player.get_unit(x)
		if current_unit != null:
			current_unit.move()
	turn_queue.shoot_all_turrets()
	turn_queue.attack_all_units()
	turn_queue.update_all_labels()
	turn_queue.set_all_goal()
	emit_signal('map_changed')
	emit_signal('simulation_phase_end')

## Disables all buttons.
## @desc:
## 		Disables all buttons from the menu.
func disable_all():
	self.simulate_button.disabled = true
	self.end_turn.disabled = true
	self.buy_units.disabled = true

## Enable all buttons.
## @desc:
## 		Enable all buttons from the menu.
func enable_all():
	if turn_queue.game_over:
		return
	self.end_turn.disabled = false
	self.buy_units.disabled = false
	self.turn_queue.increment_turn()
