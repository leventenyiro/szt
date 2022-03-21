extends Node

var noise
var map_size = Vector2(80,45)
var grass_cap = 0.45
var environment_caps = Vector3(0.4,0.3,0.04)
var environment_chance = 8
var environment_tile_count = 6
var tree_cap = 0.002
var tree_chance = 1
var road_caps = Vector2(0.1,0.11)
var castle_distance = 40

func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 16
	noise.persistence = 0.7
	generate()
	
func generate():
	create_grass_map()
	create_environment_map()
	create_water_map()
	create_road_map()
	create_prop_map()
	create_castles()

func create_grass_map():
	for x in map_size.x:
		for y in map_size.y:
			var current_noise = noise.get_noise_2d(x,y)
			if current_noise < grass_cap:
				$Grass.set_cell(x,y,0)
	$Grass.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))
			
func create_environment_map():
	for x in map_size.x:
		for y in map_size.y:
			var current_noise = noise.get_noise_2d(x,y)
			if current_noise < grass_cap:
				if current_noise < environment_caps.x and current_noise > environment_caps.y or current_noise < environment_caps.z:
					var chance = randi() % 100
					if chance < environment_chance:
						var num = randi() % environment_tile_count
						$Environment.set_cell(x,y,num)

func create_water_map():
	for x in map_size.x:
		for y in map_size.y:
			if $Grass.get_cell(x,y) == -1:
				$Water.set_cell(x,y,0)
	$Grass.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))

func create_road_map():
	for x in range(1,map_size.x-1):
		for y in range(1,map_size.y-1):
			var current_noise = noise.get_noise_2d(x,y)
			if current_noise > road_caps.x and current_noise > road_caps.y and $Grass.get_cell(x,y) == 0:
				var water_around = false
				for i in range(x-1,x+2):
					for j in range(y-1,y+2):
						if $Water.get_cell(i,j) == 0:
							water_around = true
							break
				if not water_around:
					$Roads.set_cell(x,y,0)
	$Roads.update_bitmask_region(Vector2(0.0, 0.0), Vector2(map_size.x, map_size.y))

func create_prop_map():
	for x in range(3,map_size.x-3):
		for y in range(3,map_size.y-3):
			var current_noise = noise.get_noise_2d(x,y)
			if current_noise < tree_cap and $Grass.get_cell(x,y) == 0:
				var chance = randi() % 100
				var tree_around = false
				for i in range(x-1,x+2):
					for j in range(y-1,y+2):
						if $Trees.get_cell(i,j) == 0:
							tree_around = true
							break
				if chance < tree_chance and not tree_around:
					$Trees.set_cell(x,y,0)
					
func distance(x1, y1, x2, y2):
	return sqrt(pow(abs(x1 - x2), 2) + pow(abs(y1 - y2), 2))
	
func create_castles():
	# nem lehet a map szélén, vízben, illetve a kettő legyen távol egymástól
	var is_castles_ready = false
	while (!is_castles_ready):
		var is_blue_ready = false
		var x1 = 0
		var y1 = 0
		while (!is_blue_ready):
			x1 = round(rand_range(0, map_size.x / 4))
			y1 = round(rand_range(0, map_size.y / 4))
			if $Water.get_cell(x1, y1) == -1:

				is_blue_ready = true
			
		var is_red_ready = false
		while (!is_red_ready):
			var x2 = round(rand_range(map_size.x / 4, map_size.x / 2))
			var y2 = round(rand_range(map_size.y / 4, map_size.y / 2))
			#if $Water.get_cell(x2, y2) == -1 and distance(x1, y1, x2, y2) >= 20:
			#print(distance(x1, y1, x2, y2))
			if distance(x1, y1, x2, y2) >= 20:

				is_red_ready = true
	#$BlueCastle.set_cell(x1, y1, 0)
					$RedCastle.set_cell(x2, y2, 0)
