extends Node

onready var current_player = null
onready var turn = 0
onready var blue_player = get_child(0)
onready var red_player = get_child(1)
onready var end_turn_button = get_node('/root/World/CanvasLayer/UI/Popup/VBoxContainer/HBoxContainer3/HBoxContainer2/EndTurn')
onready var simulate_button = get_node('/root/World/CanvasLayer/UI/Popup/VBoxContainer/HBoxContainer3/HBoxContainer2/Simulate')
onready var buy_units = get_node('/root/World/CanvasLayer/UI/Popup/VBoxContainer/HBoxContainer3/HBoxContainer/Button')
onready var buy_towers = get_node('/root/World/CanvasLayer/UI/Popup/VBoxContainer/HBoxContainer3/HBoxContainer/Button2')
onready var save = get_node('/root/World/CanvasLayer/UI/Popup/VBoxContainer/HBoxContainer3/HBoxContainer3/Save')

onready var loader = get_node("/root/World/Load_helper")
onready var game_over = false

signal turn_switched
signal game_over

## Emits a 'turn_switched' signal.
## @desc:
## 		Emits a 'turn_switched' signal that switches the turn to the other player.
func _on_EndTurnButton_pressed():
	emit_signal('turn_switched')

## Returns the current player.
## @desc:
## 		Returns the current player.
func get_current_player():
	return self.current_player

## Switches the turn.
## @desc:
## 		 Switches the turn to the other player.
func switch_turn():
	increment_turn()
	end_turn_button.disabled = true
	simulate_button.disabled = false

## Increments the turn counter.
## @desc:
## 		 Increments the turn counter and check for the new current player.
func increment_turn():
	turn += 1
	current_player = get_child(turn%2)

## All towers shoot.
## @desc:
## 		 Both the red player's and the blue player's towers shoot.
func shoot_all_turrets():
	red_player.shoot_turrets()
	blue_player.shoot_turrets()
	
func attack_all_units():
	red_player.attack_with_units()
	blue_player.attack_with_units()
	
func set_all_goal():
	red_player.set_goals()
	blue_player.set_goals()
	
func update_all_labels():
	red_player.update_units_count_same_tile_label()
	blue_player.update_units_count_same_tile_label()

## Ends the game.
## @desc:
## 		 Disables all buttons when one of the player's castle reaches 0 health
func end_game():
	self.end_turn_button.disabled = true
	self.simulate_button.disabled = true
	self.buy_units.disabled = true
	self.buy_towers.disabled = true
	self.save.disabled = true
	self.game_over = true
	print('GAME OVER')

## Returns the correct unit asset.
## @desc:
## 		 Returns the correct unit asset depending on the current turn.
func get_current_unit_asset_path(type):
	if self.turn % 2 == 0:
		if type == 0:
			return 'res://Map/blue_troop_castle.png'
		if type == 1:
			return 'res://Map/blue_troop_troop.png'
		if type == 2:
			return 'res://Map/blue_troop_tower.png'
	if self.turn % 2 == 1:
		if type == 0:
			return 'res://Map/red_troop_castle.png'
		if type == 1:
			return 'res://Map/red_troop_troop.png'
		if type == 2:
			return 'res://Map/red_troop_tower.png'
		


## Returns the correct tower asset.
## @desc:
## 		 Returns the correct tower asset depending on the current turn.
func get_current_tower_asset_path():
	if self.turn % 2 == 0:
		return 'res://Map/blue_tower.png'
	if self.turn % 2 == 1:
		return 'res://Map/red_tower.png'


## Saves the current player.
## @desc:
## 		 Saves the current player.
func save():
	var save_dict = {
		"current_player" : turn%2,
	}
	return save_dict

## Loads the players.
## @desc:
## 		 Loads the players from the save file data.
func _on_World_Load_game():
	current_player = get_child(loader.get_current())
	loader.get_player(blue_player,red_player)
	connect("turn_switched", self, "switch_turn")
	connect('game_over', self, 'end_game')
	emit_signal("turn_switched")

## Creates the players.
## @desc:
## 		 Creates the players with the default starter stats.
func _on_World_New_game():
	current_player = get_child(0)
	self.blue_player.set_enemy(self.red_player)
	self.red_player.set_enemy(self.blue_player)
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
