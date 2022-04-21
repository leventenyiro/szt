extends Area2D

signal health_update(health)
signal game_over

export (int) var max_health = 10

onready var health = max_health setget _set_health
onready var player = null

func _ready():
	var turn_queue = get_node('/root/World/CanvasLayer/GameLogic/TurnQueue')
	connect('game_over', turn_queue, 'end_game')

## Returns the health of the castle.
## @desc:
## 		Returns the current health of the castle. Destroys it if its 0.
func _set_health(value):
	var prev_health = health;
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("health_update",health)
		if health == 0:
			kill()
## The castle takes damage.
## @desc:
## 		The castle loses 'amount' amount of health.
func take_damage(amount):
	_set_health(health - amount)
	self.player.update_hp_label()
## Destroys the castle.
## @desc:
## 		Emits a 'game over' signal then destroys the castle node.
func kill():
	emit_signal('game_over')
	queue_free()
## Returns the castle's health.
## @desc:
## 		Returns the castle's health.
func get_health():
	return self.health
## Sets the castle's player.
## @desc:
## 		Sets the castle's player.
func set_player(player):
	self.player = player
## Saves the castle.
## @desc:
## 		Saves the current castles health,and position on the map.
func save():
	var save_dict = {
		"health" : get_health() ,
		"position.x" : get_position().x ,
		"position.y" : get_position().y ,
	}
	return save_dict
