extends PanelContainer

signal switch_current_tower(type)

onready var popup = get_node('/root/World/CanvasLayer/UI/Popup')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func button_press():
	popup._on_Button2_pressed()

func _on_ButtonBuySmall_pressed():
	button_press()
	emit_signal('switch_current_tower', 'S')


func _on_ButtonBuyMedium_pressed():
	button_press()
	emit_signal('switch_current_tower', 'M')


func _on_ButtonBuyLarge_pressed():
	button_press()
	emit_signal('switch_current_tower', 'L')
