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
onready var turn_queue = get_node('/root/World/GameLogic/TurnQueue')
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

func get_mode():
	return self._mode

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

func _clear_container():
	for x in self.container.get_children():
		container.remove_child(x)
		x.queue_free()

func _add_container(item):
	self.container.add_child(item)

func _append_units():
	var units = list_units.instance()
	units.connect('buy_simple_unit', nav, 'buy_simple_unit')
	units.connect("buy_attacker_unit", nav, 'buy_attacker_unit')
	units.connect('buy_tower_unit', nav, 'buy_tower_unit')
	self._clear_container()
	self._add_container(units)
	
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


func _on_Simulate_pressed():
	emit_signal('simulate')
