extends KinematicBody2D

# movement ------------------------
enum {
	MOVE,
	ROLL,
	ATTACK,
	SHOOT,
	CAST
}

const ACCELERATION = 1000
var roll_vector = Vector2.DOWN
var velocity    = Vector2.ZERO
var state       = MOVE

var roll_cost = 15
var sword_cost = 10
var shoot_cost = 10
var mana_cost = 10

var initial_direction = Vector2.DOWN

# ---------------------------------

onready var swordHitbox    = $HitboxPivot/SwordHitbox
onready var animationTree  = $AnimationTree
onready var animationState = animationTree.get("parameters/playback") 
onready var camera         = $Camera2D

func _ready():
	PlayerUI.get_node("Stats").visible = true
	PlayerUI.ingame = true
	PlayerUI.update_ui()
	animationTree.active = true
	animationTree.set("parameters/Idle/blend_position", initial_direction)
	
func _physics_process(delta):
	if Input.is_action_just_pressed("sword") && state == MOVE:
		if PlayerUI.stamina > sword_cost:
			PlayerUI.stamina -= sword_cost
			state = ATTACK
	elif Input.is_action_just_pressed("roll") && state == MOVE:
		if PlayerUI.stamina > roll_cost:
			PlayerUI.stamina -= roll_cost
			state = ROLL
	elif Input.is_action_just_pressed("magic") && state == MOVE:
		if PlayerUI.mana > mana_cost:
			PlayerUI.mana -= mana_cost
			state = CAST
	elif Input.is_action_just_pressed("bow") && state == MOVE:	
		if PlayerUI.stamina > shoot_cost:
			PlayerUI.stamina -= shoot_cost
			state = SHOOT
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()
		CAST:
			cast_state()
		SHOOT:
			shoot_state()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	velocity = velocity.move_toward(input_vector.normalized() * PlayerUI.speed, ACCELERATION * delta)
	
	if input_vector == Vector2.ZERO:
		animationState.travel("Idle")
	else:
		roll_vector = input_vector.normalized()
		animationTree.set("parameters/Running/blend_position", input_vector)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Running")		
	velocity = move_and_slide(velocity)

func roll_state():
	animationTree.set("parameters/Roll/blend_position", roll_vector)
	animationState.travel("Roll")
	velocity = move_and_slide(roll_vector * PlayerUI.speed * 1.25)
	
func attack_state():
	swordHitbox.knockback_vector = roll_vector
	animationState.travel("Attack")
	velocity = Vector2.ZERO
	
func cast_state():	
	state = MOVE
	
func shoot_state():	
	state = MOVE
	
func attack_animation_finished():
	state = MOVE	
	
func roll_animation_finished():
	state = MOVE	
	
