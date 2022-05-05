extends PanelContainer

signal switch_current_tower(type)

onready var popup = get_node('/root/World/CanvasLayer/UI/Popup')

func _ready():
	pass

## Controls the tower buy menu
## @desc:
## 		Controls the tower buy menu. If clicked when open the menu closes, if clicked when closed the menu opens.
func button_press():
	popup._on_Button2_pressed()
## Emmits a "switch_current_tower" with and 'S' parameter
## @desc:
## 		Emmits a "switch_current_tower" with and 'S' parameter. Switches the currently placeable tower to the S type.
func _on_ButtonBuySmall_pressed():
	button_press()
	emit_signal('switch_current_tower', 'S')

## Emmits a "switch_current_tower" with and 'M' parameter
## @desc:
## 		Emmits a "switch_current_tower" with and 'M' parameter. Switches the currently placeable tower to the M type.
func _on_ButtonBuyMedium_pressed():
	button_press()
	emit_signal('switch_current_tower', 'M')

## Emmits a "switch_current_tower" with and 'L' parameter
## @desc:
## 		Emmits a "switch_current_tower" with and 'L' parameter. Switches the currently placeable tower to the L type.
func _on_ButtonBuyLarge_pressed():
	button_press()
	emit_signal('switch_current_tower', 'L')
