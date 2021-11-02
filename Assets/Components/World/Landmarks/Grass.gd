extends Node2D

onready var sprite = $Sprite

func _on_Effect_animation_finished():
	queue_free()

func _on_Area2D_area_entered(_area):
	sprite.visible = false
