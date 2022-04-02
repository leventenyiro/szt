extends Area2D

signal health_update(health)
signal game_over

export (int) var max_health = 10

onready var health = max_health setget _set_health
onready var player = null

func _ready():
	var turn_queue = get_node('../../GameLogic/TurnQueue')
	connect('game_over', turn_queue, 'end_game')

func _set_health(value):
	var prev_health = health;
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("health_update",health)
		if health == 0:
			kill()

func take_damage(amount):
	self.player.update_hp_label()
	_set_health(health - amount)

func kill():
	emit_signal('game_over')
	queue_free()

func get_health():
	return self.health
	
func set_player(player):
	self.player = player
