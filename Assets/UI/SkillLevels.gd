extends GridContainer

onready var bow_stat           = $BowSpeedStat/StatBackground/Level
onready var mana_stat          = $ManaStat/StatBackground/Level
onready var stamina_stat       = $StaminaStat/StatBackground/Level
onready var sword_stat         = $SwordStat/StatBackground/Level
onready var bow_speed_stat     = $BowSpeedStat/StatBackground/Level
onready var mana_regen_stat    = $ManaRegenStat/StatBackground/Level
onready var stamina_regen_stat = $StaminaRegenStat/StatBackground/Level
onready var sword_speed_stat   = $SwordSpeedStat/StatBackground/Level
onready var defense_stat       = $DefenseStat/StatBackground/Level
onready var health_stat        = $HealthStat/StatBackground/Level
onready var magic_stat         = $MagicStat/StatBackground/Level
onready var speed_stat         = $SpeedStat/StatBackground/Level

onready var skill_list = [bow_stat, mana_stat, stamina_stat, sword_stat, bow_speed_stat, mana_regen_stat, stamina_regen_stat, sword_speed_stat, defense_stat, health_stat, magic_stat, speed_stat]

func update_stat_levels(stat_level_list):
	for x in range(12):
		skill_list[x].text = str(stat_level_list[x])
