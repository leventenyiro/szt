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
	popup(Rect2(_position.x,_position.y,rect_size.x,rect_size.y))
	
func _on_PopupMenu_id_pressed(id):
	match id:
		PopupIds.UPGRADE:
			print("Upgrade")
		PopupIds.REMOVE:
			Tower_Controller._remove(_position,_tower)
		
