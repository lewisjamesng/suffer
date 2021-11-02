extends CanvasLayer

func ready():
	PlayerUI.low_health()

func _on_PlayButton_level_loaded():
	PlayerUI.fade_in()
	queue_free()

func _on_ExitButton_pressed():
	get_tree().quit()
