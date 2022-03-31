extends Navigation2D

signal map_update

var mob = preload("res://Scenes/Unit.tscn")

onready var start_pos = get_node("/root/World/start_pos").get_position()
onready var end_pos = get_node("/root/World/end_pos").get_position()
onready var nav = self
onready var map = get_node("Grass")

func _ready():
	set_process_input(true)

func _on_mob_timer_timeout():
	var m = mob.instance()
	add_child(m)
	m.set_position(start_pos)
	m.goal = end_pos
	m.nav = nav
	connect("map_update", m, "update_path")
