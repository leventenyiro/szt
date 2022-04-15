extends Control

signal buy_simple_unit
signal buy_attacker_unit
signal buy_tower_unit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_ButtonBuyNormal_pressed():
	emit_signal('buy_simple_unit')


func _on_ButtonBuyAttacker_pressed():
	emit_signal('buy_attacker_unit')


func _on_ButtonBuyTower_pressed():
	emit_signal('buy_tower_unit')
