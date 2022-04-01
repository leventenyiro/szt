extends Area2D

##
## Resposible for the tower's behavior
##
## @desc:
##     Enables the tower to shoot the first unit that is in it's range

## Damage value of the tower. Can be changed in inspector
export (float) var e_damage = 1;

## Damage value of the tower
onready var damage = e_damage
var _pos

## The tower shoots the furthest unit in its range 
func _shoot():
	var units = get_overlapping_bodies();
	if units.size()>0:
		units[0].take_damage(damage)
		print("I SHOT " + units[0].get_name())
func _destroy():
	#--Give player money here when its implemented
	queue_free()


