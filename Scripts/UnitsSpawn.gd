extends Navigation2D
## Signal showing the map has updated
signal new_turn
signal map_changed
## Preloading the unit
var unit = preload("res://Scenes/Unit.tscn")
## Getting the start position of the map
onready var start_pos = get_node("/root/World/start_pos").get_position()
## Getting the end position of the map
onready var end_pos = get_node("/root/World/end_pos").get_position()
## Plane where the units navigate
onready var nav = self

func _ready():
	set_process_input(true)
## Creates a unit every button click
func _on_Button_pressed():
	var u = unit.instance()
	add_child(u)
	u.set_position(start_pos)
	u.goal = end_pos
	u.nav = nav
	connect("map_changed", u, "update_path")
	connect("new_turn", u, "move")

func _on_Button3_pressed():
	emit_signal("new_turn")

func _on_Towers_map_changed():
	emit_signal("map_changed")
