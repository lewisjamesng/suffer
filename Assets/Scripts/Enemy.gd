extends RigidBody2D

export var max_health  = 1
export var damage      = 1
export var chase_speed = 40

var player_in_range = false
var player
var health setget set_health

func _ready():
	health = max_health
	
func set_health(value):
	health = value
	#take damage animation
	
func attack():
	PlayerUI.health -= damage

func _process(delta):
	if player_in_range:
		position.move_toward(player.transform, chase_speed * delta)

func _on_DetectionArea_body_entered(body):
	if body.get_collision_layer_bit(1) :
		player_in_range = true
		player = body

func _on_DetectionArea_body_exited(body):
	if body.get_collision_layer_bit(1) :
		player_in_range = false
