extends Area2D

var knockback_vector = Vector2.ZERO
var knockbackSpeed = 10

func hit_body(body):
	body.velocity = knockback_vector * knockbackSpeed
