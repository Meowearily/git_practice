class_name GameScene
extends Node2D

var game_end = false;

var moves = 0
var Floor = preload("res://scenes/game/characters/floor.tscn")
var Wall = preload("res://scenes/game/characters/wall.tscn")
var Player = preload("res://scenes/game/characters/player.tscn")
var Crate = preload("res://scenes/game/characters/crate.tscn")
var Goal = preload("res://scenes/game/characters/goal.tscn")
var complete_sound = preload("res://assets/jingles_PIZZI16.ogg")

var GRID_SIZE = 128;


func generate_level(level_data: Variant) -> void:
	var best_moves = Global.get_best_record()
	if best_moves <= 0:
		best_moves = ""
	$MarginContainer/VBoxContainer/BestMovesContainer/BestMovesLabel.text = "Best Moves: " + str(best_moves)
	$MarginContainer/VBoxContainer/LevelContainer/LevelLabel.text = "Level: " + str(Global.level_index + 1)

	# TODO: Add valid level validation
	var row_index: int = 0
	var char_index: int = 0
	for row in level_data:
		char_index = 0
		for char in row:
			#if char == ".":
			var floor = Floor.instantiate()
			$Floors.add_child(floor)
			floor.position.x = char_index * GRID_SIZE
			floor.position.y = row_index * GRID_SIZE
			if char == "#":
				var wall = Wall.instantiate()
				$Walls.add_child(wall)
				wall.position.x = char_index * GRID_SIZE
				wall.position.y = row_index * GRID_SIZE
			if char == "@" or char == "A":
				var player = Player.instantiate()
				$Players.add_child(player)
				player.position.x = char_index * GRID_SIZE
				player.position.y = row_index * GRID_SIZE
			if char == "X" or char == "C":
				var crate = Crate.instantiate()
				$Crates.add_child(crate)
				crate.position.x = char_index * GRID_SIZE
				crate.position.y = row_index * GRID_SIZE
			if char == "O" or char == "C" or char == "A":
				var goal = Goal.instantiate()
				$Goals.add_child(goal)
				goal.position.x = char_index * GRID_SIZE
				goal.position.y = row_index * GRID_SIZE
			char_index += 1
		while char_index < 15:
			var wall = Wall.instantiate()
			$Walls.add_child(wall)
			wall.position.x = char_index * GRID_SIZE
			wall.position.y = row_index * GRID_SIZE
			char_index += 1
		row_index+= 1
	while row_index < 9:
		char_index = 0
		while char_index < 15:
			var wall = Wall.instantiate()
			$Walls.add_child(wall)
			wall.position.x = char_index * GRID_SIZE
			wall.position.y = row_index * GRID_SIZE
			char_index += 1
		row_index+= 1
		


func cleanup_level(node: Node) -> void:
	for child in node.get_children():
		node.remove_child(child)
		child.queue_free()


func _ready():
	if len(Global.level_data[Global.mod_pack_id][Global.level_pack_id]) <= Global.level_index:
		# All level solved, return to main scene
		get_tree().change_scene_to_file("res://scenes/main/main_scene.tscn")
	else:
		generate_level(Global.level_data[Global.mod_pack_id][Global.level_pack_id][Global.level_index])
		if Global.level_index == 0:
			$PreviousButton.hide()
		else:
			$PreviousButton.show()
		if Global.level_index + 1 == Global.level_data[Global.mod_pack_id][Global.level_pack_id].size():
			$ProceedButton.hide()
		else:
			$ProceedButton.show()


func _process(_delta):
	$MarginContainer/VBoxContainer/MovesContainer/MovesLabel.text = "Moves: " + str(moves)
	$Players.get_child(0)  # TODO: handle with multiple children
	var goals = $Goals.get_child_count()
	for i in $Goals.get_children():
		if i.occupied:
			goals -=1
	if goals == 0 and game_end == false:
		Global.save_best_record(moves)
		#$ProceedButton.show()
		$AudioStreamPlayer2D.stream = complete_sound
		$AudioStreamPlayer2D.play()
		game_end = true
