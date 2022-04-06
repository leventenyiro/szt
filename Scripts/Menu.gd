extends Node2D
var _load
func _on_Start_pressed():
	_load=false
	var game =load("res://Scenes/World.tscn").instance()
	game._load=_load
	get_parent().add_child(game)
	queue_free()



func _on_Load_pressed():
	var save_game = File.new()
	if save_game.file_exists("user://savegame.save"):
		_load=true
		var game =load("res://Scenes/World.tscn").instance()
		game._load=_load
		get_parent().add_child(game)
		queue_free()
	else:
		$Label.visible=true
		
	
