extends PopupMenu
onready var Tower_Controller = get_node("/root/World/Towers")
enum PopupIds{
	UPGRADE,
	REMOVE
}
var _position
var _tower
func _ready():
	add_item("Upgrade",PopupIds.UPGRADE)
	add_item("Remove",PopupIds.REMOVE)

func _popup(tower,position):
	_position = position
	_tower=tower
	popup(Rect2(_position.x+10,_position.y+10,rect_size.x,rect_size.y))
	print(tower.damage)
	
func _on_PopupMenu_id_pressed(id):
	match id:
		PopupIds.UPGRADE:
			_tower._upgrade()
		PopupIds.REMOVE:
			Tower_Controller._remove(_position,_tower,_tower.player)
		
