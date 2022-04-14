extends Node

onready var units = []
onready var towers = []
onready var enemy_player = null
onready var castle = null
onready var gold = 3000

func _ready():
	update_gold_label()
	update_unit_count_label()

## Adds a new tower to the player.
## @desc:
## 		Adds a new tower to the player.
func append_tower(tower):
	self.towers.append(tower)

## Adds a new unit to the player.
## @desc:
## 		Adds a new unit to the player.
func append_unit(unit):
	self.units.append(unit)

## Remove a unit from the player.
## @desc:
## 		Removes the 'index' positioned unit from the player.
func remove_unit(index):
	if index >= self.units.size():
		return
	self.units.remove(index)
	
## Sets the enemy of the player.
## @desc:
## 		Sets the enemy of the player.
func set_enemy(enemy):
	self.enemy_player = enemy

## Returns the enemy of the player.
## @desc:
## 		Returns the enemy of the player.
func get_enemy():
	return self.enemy_player

## Set the castle of the player.
## @desc:
## 		Set the castle of the player.
func set_castle(castle):
	self.castle = castle

## Returns the castle of the player.
## @desc:
## 		Returns the castle of the player.
func get_castle():
	return self.castle

## Returns the unit's size.
## @desc:
## 		Returns the number of units the player has.
func get_units_size():
	return self.units.size()

## Returns a specific unit.
## @desc:
## 		Returns the 'x' positioned unit from the player's units.
func get_unit(x):
	if x >= self.units.size():
		return null
	return self.units[x]

## Removes a specific unit.
## @desc:
## 		Finds the unit in the array then removes it from the player.
func erase_unit(unit):
	var i = units.find(unit)
	self.units.remove(i)

## All towers shoot.
## @desc:
## 		All the player's tower shoot the nearest enemy unit in its range.
func shoot_turrets():
	for turret in self.towers:
		turret.shoot()

## Decreases the player's gold.
## @desc:
## 		Decreases the player's gold by 'amount' amount and updates the gold label.
func decrease_gold(amount):
	self.gold -= amount
	update_gold_label()

## Adds to the player's gold.
## @desc:
## 		Adds to the player's gold by 'amount' amount and updates the gold label.
func add_gold(amount):
	self.gold += amount
	update_gold_label()
	
## Sets the player's gold.
## @desc:
## 		Sets the player's gold to 'amount' amount and updates the gold label.
func set_gold(amount):
	self.gold = amount
	update_gold_label()

## Updates the gold label.
## @desc:
## 		Updates the gold label of the player to their current gold count.
func update_gold_label():
	get_child(0).text = str(self.gold)

## Updates the health label.
## @desc:
## 		Updates the health label of the player's castle to it's current health count.
func update_hp_label():
	var castle = weakref(self.castle)
	if castle.get_ref():
		get_child(1).text = str(castle.get_ref().get_health())
	else:
		get_child(1).text = '0'
	
## Updates the units label.
## @desc:
## 		Updates the units label of the player's to it's current unit count.
func update_unit_count_label():
	get_child(2).text = str(self.get_units_size())

## Updates the units count same tile label.
## @desc:
## 		Updates the units count same tile label of the player's to it's current unit count on per tile.
func update_units_count_same_tile_label():
	for x in range(self.get_units_size()):
		var count_same_pos = 0
		var current_unit = self.get_unit(x)
		if current_unit != null:
			for y in range(self.get_units_size()):
				if current_unit.get_position() == self.get_unit(y).get_position():
					count_same_pos += 1
			current_unit.get_child(3).text = str(count_same_pos)

## Saves the player.
## @desc:
## 		Saves the player's castle,towers,units and gold.
func save():
	var tower_saves=[] 
	for tower in towers:
		tower_saves.append(tower.save())
	
	var unit_saves=[] 
	for unit in units:
		unit_saves.append(unit.save())
		
	var save_dict = {
		"castle" : castle.save(),
		"gold" : gold,
		"towers" : tower_saves,
		"units" : unit_saves
	}
	return save_dict
