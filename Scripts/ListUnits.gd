extends Control

signal buy_simple_unit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_ButtonBuyNormal_pressed():
	emit_signal('buy_simple_unit')