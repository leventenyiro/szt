extends Node

onready var current_player = null
onready var turn = 0
onready var blue_player = get_child(0)
onready var red_player = get_child(1)
onready var end_turn_button = get_node('../EndTurnButton')
onready var simulate_button = get_node('../SimulateButton')
onready var buy_units = get_node('../BuyUnits')
onready var game_over = false
signal turn_switched
signal game_over

func _ready():
	current_player = get_child(0)
	self.blue_player.set_enemy(self.red_player)
	self.red_player.set_enemy(self.blue_player)
	yield(get_parent().get_parent(),"generation_complete")
	var blue_castle = get_parent().get_parent().get_node("BlueCastle").get_child(0)
	var red_castle = get_parent().get_parent().get_node("RedCastle").get_child(0)
	self.blue_player.set_castle(blue_castle)
	self.red_player.set_castle(red_castle)
	blue_castle.set_player(blue_player)
	red_castle.set_player(red_player)
	self.blue_player.update_hp_label()
	self.red_player.update_hp_label()
	connect("turn_switched", self, "switch_turn")
	connect('game_over', self, 'end_game')

func _on_EndTurnButton_pressed():
	emit_signal('turn_switched')

func get_current_player():
	return self.current_player

func switch_turn():
	increment_turn()
	end_turn_button.disabled = true
	simulate_button.disabled = false

func increment_turn():
	turn += 1
	current_player = get_child(turn%2)

func shoot_all_turrets():
	red_player.shoot_turrets()
	blue_player.shoot_turrets()

func end_game():
	self.end_turn_button.disabled = true
	self.simulate_button.disabled = true
	self.buy_units.disabled = true
	self.game_over = true
	print('GAME OVER')
	
func get_current_unit_asset_path():
	if self.turn % 2 == 0:
		return 'res://Map/blue_troop_castle.png'
	if self.turn % 2 == 1:
		return 'res://Map/red_troop_castle.png'

func get_current_tower_asset_path():
	if self.turn % 2 == 0:
		return 'res://Map/blue_tower.png'
	if self.turn % 2 == 1:
		return 'res://Map/red_tower.png'
