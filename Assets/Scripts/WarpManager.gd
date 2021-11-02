extends Node2D

onready var level = get_tree().get_root().get_node("Level")
var path = ""
var player_entered = false

var level_names = ["1-Village", "1-Dungeon", "1a-House"]
var level_positions = [Vector2.DOWN, Vector2(104, 176), Vector2(183, 143)]

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : path,
		"player_entered" : player_entered,
		"level_names" : level_names,
		"level_positions" : level_positions
	}
	return save_dict

static func delete_children(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _process(_delta):
	if player_entered && Input.is_action_just_pressed("interact"):
		swap_scene()

func swap_scene():
	var player
	var index
	var direction
	PlayerUI.fade_out()
	yield(get_tree().create_timer(2), "timeout")
	for n in level.get_children():
		player = n.get_node("WorldObjects/Player")
		index = level_names.find(n.get_name())
		level_positions[index] = player.position
		direction = player.roll_vector
		n.queue_free()
	var new_area = (load(path)).instance()
	player = new_area.get_node("WorldObjects/Player")
	index = level_names.find(new_area.get_name())
	player.position = level_positions[index]
	player.initial_direction = direction
	level.add_child(new_area)
	PlayerUI.fade_in()


