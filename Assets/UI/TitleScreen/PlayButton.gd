extends Button

onready var level = get_tree().get_root().get_node("Level")
onready var fade_player = $FadePlayer
var path = "res://Assets/World/1-Village.tscn"

signal level_loaded
		
func _on_PlayButton_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	fade_player.play("fade_in")

func _on_FadePlayer_animation_finished(_anim_name):
	level.add_child(load(path).instance())
	emit_signal("level_loaded")
