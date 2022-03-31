extends Area2D


export (float) var e_damage = 1;

onready var damage = e_damage

var _timer = null
var shootable=true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(1.5)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

func _on_Timer_timeout():
	if !shootable:
		shootable=true
		
func _process(delta):
	var units = get_overlapping_bodies();
	if shootable && units.size()>0:
		_attack(units[0])
		
func _attack(unit):
	unit.damage(damage)
	shootable=false;
	print("I SHOT " + unit.get_name())


