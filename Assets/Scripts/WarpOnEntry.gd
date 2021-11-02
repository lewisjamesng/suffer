extends Area2D

export var path = ""

func _on_WarpOnEntry_body_entered(body):
	if body.get_collision_layer_bit(1) :
		WarpManager.path = path
		WarpManager.player_entered = true
		PlayerUI.interact.visible = true

func _on_WarpOnEntry_body_exited(body):
	if body.get_collision_layer_bit(1) :
		WarpManager.player_entered = false
		PlayerUI.interact.visible = false
