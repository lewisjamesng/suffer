extends CanvasLayer

onready var health_bar   = $Stats/StatBars/Health
onready var mana_bar     = $Stats/StatBars/Mana
onready var stamina_bar  = $Stats/StatBars/Stamina
onready var xp_bar       = $Stats/StatBars/XP
onready var fade_player  = $FadePlayer
onready var flash_player = $FlashPlayer
onready var level_label  = $Stats/Control/Level
onready var interact     = $Interact


onready var level_holder = get_tree().get_root().get_node("Level")
onready var inventory    = $Inventory
onready var level_up_menu = $LevelUp
var inventory_open = false
var ingame = false

onready var stat_levels = $Inventory/HBoxContainer/Control/VBoxContainer/StatLevels
onready var level_up_stat_levels = $LevelUp/Control/LevelUpStatLevels

# ------------------------------------------------------------
#player levels
var max_health_level  = 1 
var max_mana_level    = 1
var max_stamina_level = 1
var defense_level     = 1
var speed_level       = 1

var sword_attack_damage_level = 1
var sword_attack_speed_level  = 1
var bow_attack_damage_level   = 1
var bow_attack_speed_level    = 1
var magic_attack_damage_level = 1

var mana_regen_level = 1
var stamina_regen_level = 1

# var stat_levels = [bow_attack_damage_level, max_mana_level, max_stamina_level, sword_attack_damage_level, bow_attack_speed_level, mana_regen_level, stamina_regen_level, sword_attack_speed_level, defense_level, max_health_level, magic_attack_damage_level, speed_level]

# player skill stats --------------
var stat_scaling_array =  [2, 3, 4.5, 7, 9, 12, 16, 21, 27]

var max_health  = 10 * stat_scaling_array[max_health_level]

var max_mana    = 50 * stat_scaling_array[max_mana_level]

var max_stamina = 50 * stat_scaling_array[max_stamina_level]

var defense     = (10 * defense_level - 10) / 3

var speed       = 40 + (speed_level - 1) * (20 / 8)

var sword_attack_damage = 0.5 * stat_scaling_array[sword_attack_damage_level]

var sword_attack_speed  = 1 - (sword_attack_speed_level - 1) / 16

var bow_attack_damage   = 0.5 * stat_scaling_array[bow_attack_damage_level]

var bow_attack_speed    = 1 - (bow_attack_speed_level - 1) / 16

var magic_attack_damage = 0.5 * stat_scaling_array[magic_attack_damage_level]

var stamina_regen = max_stamina / (9 - stamina_regen_level) 
var mana_regen    = max_mana / 10

#----------------------------------

# current player stats ------------
var health  : float = max_health  setget set_health
var xp      : float = 0           setget set_xp
var mana    : float = max_mana    setget set_mana
var stamina : float = max_stamina setget set_stamina
var level   : int   = 1           
var xp_per_level    = 50 * pow(1.2, level)
var arrows          = 0           setget set_arrows
# ---------------------------------

func save():
	var save_dict = {
		"filename" : get_filename(),
		"max_health_level" : max_health_level, 
		"max_mana_level" : max_mana_level,
		"max_stamina_level" : max_stamina_level,
		"defense_level" : defense_level,
		"speed_level" : speed_level,
		"sword_attack_damage_level" : sword_attack_damage_level,
		"sword_attack_speed_level" : sword_attack_speed_level,
		"bow_attack_damage_level" : bow_attack_damage_level,
		"bow_attack_speed_level" : bow_attack_speed_level,
		"magic_attack_damage_level" : magic_attack_damage_level,
		"mana_regen_level" : mana_regen_level,
		"stamina_regen_level" : stamina_regen_level,
		"health" : health,
		"xp" : xp,
		"mana" : mana,
		"stamina" : stamina,
		"level" : level,
		"xp_per_level" : xp_per_level,
		"arrows" : arrows
	}
	return save_dict

func ready():
	update_ui()
	reset_max_stats()

func _process(delta):
	# regen ---------------
	set_stamina(min(stamina + stamina_regen * delta,max_stamina))
	set_mana(min(mana + mana_regen * delta, max_mana))
	if Input.is_action_just_pressed("inventory") && ingame:
		if !inventory_open:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		inventory.visible = !inventory_open
		inventory_open = !inventory_open

func set_arrows(value):
	arrows = value

func set_health(value):
	health = value
	if (health < max_health * 0.15):
		PlayerUI.low_health()
	else:
		high_health()
	update_stats()

func set_mana(value):
	mana = value
	update_stats()
	
func set_stamina(value):
	stamina = value
	update_stats()
	
func set_xp(value):
	xp += value
	if xp > xp_per_level:
		if level == 85:
			xp = xp_per_level
		else:
			xp -= xp_per_level
			level += 1
			level_up()
	update_stats()

func update_ui():
	update_stat_levels([bow_attack_damage_level, max_mana_level, max_stamina_level, sword_attack_damage_level, bow_attack_speed_level, mana_regen_level, stamina_regen_level, sword_attack_speed_level, defense_level, max_health_level, magic_attack_damage_level, speed_level])
	update_stats()
	update_max_stats()

# animations --------------------------------
func fade_out():
	fade_player.play("fade_out")
	
func fade_in():
	fade_player.play_backwards("fade_out")

func low_health():
	flash_player.play("low_health")

func high_health():
	flash_player.stop()
# --------------------------------------------
	
	
# update ui ----------------------------------
func update_stats():
	health_bar.value  = health 
	mana_bar.value    = mana
	stamina_bar.value = stamina
	xp_bar.value      = xp

func update_max_stats():
	health_bar.max_value  = max_health 
	mana_bar.max_value    = max_mana
	stamina_bar.max_value = max_stamina
	xp_bar.max_value      = xp_per_level
	
func update_stat_levels(stat_level_list):
	stat_levels.update_stat_levels(stat_level_list)
	level_up_stat_levels.update_stat_levels(stat_level_list)
	
# --------------------------------------------
func reset_current_stats():
	health 			= max_health 
	mana   			= max_mana    
	stamina         = max_stamina    
	xp_per_level    = 50 * pow(1.2, level)   

func reset_max_stats():
	max_health  = 10 * stat_scaling_array[max_health_level]
	max_mana    = 50 * stat_scaling_array[max_mana_level]
	max_stamina = 50 * stat_scaling_array[max_stamina_level]
	defense     = (10 * defense_level - 10) / 3
	speed       = 40 + (speed_level - 1) * (20 / 8)
	sword_attack_damage = 0.5 * stat_scaling_array[sword_attack_damage_level]
	sword_attack_speed  = 1 - (sword_attack_speed_level - 1) / 16
	bow_attack_damage   = 0.5 * stat_scaling_array[bow_attack_damage_level]
	bow_attack_speed    = 1 - (bow_attack_speed_level - 1) / 16
	magic_attack_damage = 0.5 * stat_scaling_array[magic_attack_damage_level]
	stamina_regen = max_stamina / (9 - stamina_regen_level) 
	mana_regen    = max_mana / 10

func level_up():
	level_up_menu.visible = true
	level_holder.pause_mode = Node.PAUSE_MODE_STOP
	
	
func _on_StatBackground_pressed(stat):
	match(stat):
		"bow":
			bow_attack_damage_level += 1
			if bow_attack_damage_level == 8:
				level_up_stat_levels.disable_button(stat)
		"mana":
			max_mana_level +=1
			if max_mana_level == 8:
				level_up_stat_levels.disable_button(stat)
		"stamina":
			max_stamina_level += 1
			if max_stamina_level == 8:
				level_up_stat_levels.disable_button(stat)
		"sword":
			sword_attack_damage_level += 1
			if sword_attack_damage_level == 8:
				level_up_stat_levels.disable_button(stat)
		"bow_speed":
			bow_attack_speed_level += 1
			if bow_attack_speed_level == 8:
				level_up_stat_levels.disable_button(stat)
		"mana_regen":
			mana_regen_level += 1
			if mana_regen_level == 8:
				level_up_stat_levels.disable_button(stat)
		"stamina_regen":
			stamina_regen_level += 1
			if stamina_regen_level == 8:
				level_up_stat_levels.disable_button(stat)
		"sword_speed":
			sword_attack_speed_level += 1
			if sword_attack_speed_level == 8:
				level_up_stat_levels.disable_button(stat)
		"defense":
			defense_level += 1
			if defense_level == 8:
				level_up_stat_levels.disable_button(stat)
		"health":
			max_health_level += 1
			if max_health_level == 8:
				level_up_stat_levels.disable_button(stat)
		"magic":
			magic_attack_damage_level += 1
			if magic_attack_damage_level == 8:
				level_up_stat_levels.disable_button(stat)
		"speed":
			speed_level += 1
			if speed_level == 8:
				level_up_stat_levels.disable_button(stat)
	level_up_menu.visible = false
	level_holder.pause_mode = Node.PAUSE_MODE_INHERIT
	reset_max_stats()
	reset_current_stats()
	update_ui()
	

	
