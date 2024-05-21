class_name SelectScene
extends Node2D


var LevelCategory = preload("res://scenes/select/level_category.tscn")
var Wall = preload("res://scenes/game/characters/wall.tscn")
var GRID_SIZE = 128;

func _ready():
	for mod_pack in Global.level_data:
		for level_pack in Global.level_data[mod_pack].keys():
			var level_category = LevelCategory.instantiate()
			print(len(Global.level_data[mod_pack][level_pack]))
			level_category.generate(mod_pack, level_pack, len(Global.level_data[mod_pack][level_pack]))
			$ScrollContainer/VBoxContainer.add_child(level_category)
	
	for row_index in range(9):
		for char_index in range(15):
			var wall = Wall.instantiate()
			$Walls.add_child(wall)
			wall.position.x = char_index * GRID_SIZE
			wall.position.y = row_index * GRID_SIZE
	return
