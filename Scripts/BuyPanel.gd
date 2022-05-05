extends Control

export var menu_size = 0.35
export var popup_speed = 0.25

var _popped_up = false
var _up_anchor = Vector2(1-menu_size, 1)
var _down_anchor = Vector2(1,1+menu_size)
var _target_anchor = _down_anchor
var _mode = -1

onready var container = get_node("VBoxContainer/MarginContainer")
onready var nav = get_node('/root/World/Nav')
onready var turn_queue = get_node('/root/World/CanvasLayer/GameLogic/TurnQueue')
onready var towers_map = get_node('/root/World/Towers')
var list_towers = preload("res://Scenes/ListTowers.tscn")
var list_units = preload("res://Scenes/ListUnits.tscn")

signal turn_switched
signal simulate

func _ready():
	connect('turn_switched', turn_queue, '_on_EndTurnButton_pressed')
	connect('simulate', nav, '_on_SimulateButton_pressed')

func _process(_delta):
	anchor_top = lerp(anchor_top, _target_anchor.x,self.popup_speed)
	anchor_bottom = lerp(anchor_bottom, _target_anchor.y, self.popup_speed)
## Returns the mode of the menu.
## @desc:
## 		Returns the mode of the menu.
func get_mode():
	return self._mode
## Controls the unit buy menu
## @desc:
## 		Controls the unit buy menu. If clicked when open the menu closes, if clicked when closed the menu opens.
func _on_Button_pressed():
	if self._popped_up and self._mode == 1:
		self._mode = 0
		self._append_units()
		return
	if !self._popped_up:
		_target_anchor = _up_anchor
		self._mode = 0
		self._append_units()
	if self._popped_up and self._mode == 0:
		_target_anchor = _down_anchor
		self._mode = -1
	self._popped_up = !self._popped_up

## Controls the tower buy menu
## @desc:
## 		Controls the tower buy menu. If clicked when open the menu closes, if clicked when closed the menu opens.
func _on_Button2_pressed():
	if self._popped_up and self._mode == 0:
		self._mode = 1
		self._append_towers()
		return
	if !self._popped_up:
		_target_anchor = _up_anchor
		self._mode = 1
		self._append_towers()
	if self._popped_up and self._mode == 1:
		_target_anchor = _down_anchor
		self._mode = -1
	self._popped_up = !self._popped_up
## Clears the menu.
## @desc:
## 		Clears the menu from all options.
func _clear_container():
	for x in self.container.get_children():
		container.remove_child(x)
		x.queue_free()
## Adds and option to the menu.
## @desc:
## 		Adds an "item" option to the menu selection.
func _add_container(item):
	self.container.add_child(item)
## Creates the unit shop menu.
## @desc:
## 		Creates the unit shop menu with all available units.
func _append_units():
	var units = list_units.instance()
	units.connect('buy_simple_unit', nav, 'buy_simple_unit')
	units.connect("buy_attacker_unit", nav, 'buy_attacker_unit')
	units.connect('buy_tower_unit', nav, 'buy_tower_unit')
	self._clear_container()
	self._add_container(units)
## Creates the tower shop menu.
## @desc:
## 		Creates the tower shop menu with all available towers.
func _append_towers():
	var towers = list_towers.instance()
	towers.connect('switch_current_tower', self.towers_map, 'switch_current')
	self._clear_container()
	self._add_container(towers)

## Emits a 'turn_switched' signal.
## @desc:
## 		Emits a 'turn_switched' signal that switches the turn to the other player.
func _on_EndTurn_pressed():
	emit_signal('turn_switched')

## Emits a 'simulate' signal.
## @desc:
## 		Emits a 'simulate' signal that simulates a round.
func _on_Simulate_pressed():
	emit_signal('simulate')
