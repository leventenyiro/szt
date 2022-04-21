extends TileMap


signal map_changed
onready var Tower =  preload("res://Scenes/MTower.tscn")
onready var grass = get_node("/root/World/Nav/Grass")
onready var roads = get_node("/root/World/Roads")
onready var turn_queue = get_node('/root/World/CanvasLayer/GameLogic/TurnQueue')
onready var nav = get_node('/root/World/Nav')

func switch_current(type):
	self.Tower = load(str("res://Scenes/", type, "Tower.tscn"))
	print(self.Tower)

## Places a tower if possible.
## @desc:
## 		Places a tower on the clicked tile if possible.
func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var mouse_pos = get_global_mouse_position()
		var tile_pos = map_to_world(world_to_map(mouse_pos))
		if event.button_index == BUTTON_LEFT:
			if get_cell(tile_pos.x, tile_pos.y) == -1 and grass.get_cell(tile_pos.x/16, tile_pos.y/16) == 0: 
				var Tower_Instance = Tower.instance()
				var current_player = get_parent().get_node("CanvasLayer").get_child(0).get_child(0).get_current_player()
				if Tower_Instance.cost > current_player.gold or !_placeable(current_player,tile_pos) or _placeable(current_player.get_enemy(),tile_pos):
					return
				grass.set_cell(tile_pos.x/16, tile_pos.y/16,-1)
				roads.set_cell(tile_pos.x/16, tile_pos.y/16,0)
				var path = nav.get_simple_path(current_player.get_castle().get_position(), current_player.get_enemy().get_castle().get_position(), false)
				if path.size()==0:
					grass.set_cell(tile_pos.x/16, tile_pos.y/16,0)
					return
				Tower_Instance.get_child(0).texture = load(turn_queue.get_current_tower_asset_path())
				current_player.append_tower(Tower_Instance)
				Tower_Instance.set_player(current_player)
				Tower_Instance.set_position(Vector2(tile_pos.x,tile_pos.y))
				var map_size = Vector2(1280,720)
				grass.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
				roads.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
				current_player.decrease_gold(Tower_Instance.cost)
				self.add_child(Tower_Instance)
				set_cell(tile_pos.x, tile_pos.y,0)
				_map_changed()

## Loads the tower.
## @desc:
## 		Loads the tower's data and initializes it.
func place_from_load(tower,current_player,color):
			var Tower_Instance = Tower.instance()
			grass.set_cell(tower["position.x"]/16, tower["position.y"]/16,-1)
			Tower_Instance.get_child(0).texture = load(str('res://Map/',color,'_tower.png'))
			current_player.append_tower(Tower_Instance)
			Tower_Instance.set_player(current_player)
			Tower_Instance.set_position(Vector2(tower["position.x"],tower["position.y"]))
			self.add_child(Tower_Instance)
			Tower_Instance._set_damage(tower["damage"])
			Tower_Instance._set_cost(tower["cost"])
			Tower_Instance._set_upgrade_cost(tower["upgrade_cost"])
			set_cell(tower["position.x"], tower["position.y"],0)
			_map_changed()

## Removes the tower from the players.
## @desc:
## 		Removes the tower from the '_player' thats on the 'tile_pos' position.
func _remove(tile_pos,item,_player):
	item._destroy()
	_player.towers.erase(item)
	set_cell(tile_pos.x, tile_pos.y,-1)
	grass.set_cell(tile_pos.x/16, tile_pos.y/16,0)
	grass.update_bitmask_region(Vector2(0.0, 0.0),  Vector2(80,45))
	_map_changed()
	
## Checks if the tower is placeable.
## @desc:
## 		Checks if the tower is placeable, not placeable on water,near enemy towers/castle or outside of the player's own towers/castle range
func _placeable(_player,tower_pos):
	if _player.get_castle().get_position() == tower_pos:
		return false
	if _player.get_castle().global_position.distance_to(Vector2(tower_pos.x, tower_pos.y)) <= 46:
		return true
	for turret in _player.towers:
		if turret.global_position.distance_to(Vector2(tower_pos.x, tower_pos.y)) <= 46:
			return true
	return false

## Emits a 'new_turn' signal.
## @desc:
## 		Emits a 'new_turn' signal that end the current turn.
func _new_turn():
	emit_signal("new_turn")

## Emits a 'map_changed' signal.
## @desc:
## 		Emits a 'map_changed' signal that tells other nodes that the map has changed.
func _map_changed():
	emit_signal("map_changed")

