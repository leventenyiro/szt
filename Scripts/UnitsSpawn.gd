extends Navigation2D
## Signal showing the map has updated
signal map_changed
signal simulation_phase_start
signal simulation_phase_end
## Preloading the unit
var unit = preload("res://Scenes/Unit.tscn")
## Plane where the units navigate
onready var nav = self

onready var turn_queue = get_node('../GameLogic/TurnQueue')
onready var simulate_button = get_node('../GameLogic/SimulateButton')
onready var buy_units = get_node('../GameLogic/BuyUnits')
onready var end_turn = get_node('../GameLogic/EndTurnButton')

func _ready():
	set_process_input(true)
	connect("simulation_phase_start", self, 'disable_all')
	connect("simulation_phase_end", self, 'enable_all')
## Creates a unit every button click
func _on_BuyUnits_pressed():
	var current_player = turn_queue.current_player
	initialize_unit(current_player)

func _on_Towers_map_changed():
	var current_player = turn_queue.current_player
	emit_signal("map_changed")
	
func initialize_unit(current_player):
	var unit_instance = unit.instance()
	if unit_instance.cost > current_player.gold:
		return
	unit_instance.set_player(current_player)
	unit_instance.set_position(current_player.get_castle().get_position())
	unit_instance.goal = current_player.get_enemy().get_castle().get_position()
	unit_instance.nav = nav
	unit_instance.get_child(0).texture = load(turn_queue.get_current_unit_asset_path())
	add_child(unit_instance)
	current_player.decrease_gold(unit_instance.cost)
	connect("map_changed", unit_instance, "update_path")
	current_player.append_unit(unit_instance)
	current_player.update_unit_count_label()


func _on_SimulateButton_pressed():
	emit_signal('simulation_phase_start')
	while turn_queue.blue_player.get_units_size() > 0 or turn_queue.red_player.get_units_size() > 0:
		var t = Timer.new()
		t.set_wait_time(0.1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		for x in range(turn_queue.blue_player.get_units_size()):
			var current_unit = turn_queue.blue_player.get_unit(x)
			if current_unit != null:
				current_unit.move()
		for x in range(turn_queue.red_player.get_units_size()):
			var current_unit = turn_queue.red_player.get_unit(x)
			if current_unit != null:
				current_unit.move()
		turn_queue.shoot_all_turrets()
		yield(t,"timeout")
	emit_signal('simulation_phase_end')

func disable_all():
	self.simulate_button.disabled = true
	self.end_turn.disabled = true
	self.buy_units.disabled = true
	
func enable_all():
	if turn_queue.game_over:
		return
	self.end_turn.disabled = false
	self.buy_units.disabled = false
	self.turn_queue.increment_turn()
