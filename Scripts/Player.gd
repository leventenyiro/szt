extends Node

onready var units = []
onready var towers = []
onready var enemy_player = null
onready var castle = null
onready var gold = 3000


# Called when the node enters the scene tree for the first time.
func _ready():
	update_gold_label()
	update_unit_count_label()

func append_tower(tower):
	self.towers.append(tower)
	
func append_unit(unit):
	self.units.append(unit)
	
func remove_unit(index):
	if index >= self.units.size():
		return
	self.units.remove(index)
	
func set_enemy(enemy):
	self.enemy_player = enemy
	
func get_enemy():
	return self.enemy_player

func set_castle(castle):
	self.castle = castle
	
func get_castle():
	return self.castle
	
func get_units_size():
	return self.units.size()
	
func get_unit(x):
	if x >= self.units.size():
		return null
	return self.units[x]

func erase_unit(unit):
	var i = units.find(unit)
	self.units.remove(i)

func shoot_turrets():
	for turret in self.towers:
		turret.shoot()
		
func decrease_gold(amount):
	self.gold -= amount
	update_gold_label()

func add_gold(amount):
	self.gold += amount
	update_gold_label()
	
func set_gold(amount):
	self.gold = amount
	update_gold_label()
func update_gold_label():
	get_child(0).text = str(self.gold)
	
func update_hp_label():
	var castle = weakref(self.castle)
	if castle.get_ref():
		get_child(1).text = str(castle.get_ref().get_health())
	else:
		get_child(1).text = '0'
	
func update_unit_count_label():
	get_child(2).text = str(self.get_units_size())

func save():
	var tower_saves=[] 
	for tower in towers:
		tower_saves.append(tower.save())
		
	var save_dict = {
		"castle" : castle.save(),
		"gold" : gold,
		"towers" : tower_saves
	}
	return save_dict
