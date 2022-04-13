extends PanelContainer

signal switch_current_tower(type)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ButtonBuySmall_pressed():
	emit_signal('switch_current_tower', 'S')


func _on_ButtonBuyMedium_pressed():
	emit_signal('switch_current_tower', 'M')


func _on_ButtonBuyLarge_pressed():
	emit_signal('switch_current_tower', 'L')
