extends RichTextLabel

onready var file = "res://Assets/UI/Dialogue Box/Dialogue.tres"


onready var textSequence = [] #= ["Hello, my name is Guolin", "This is a dialogue box for clownfiesta", "3", "4"]
var page = 0

func _ready():
	load_file(file)
	set_bbcode(textSequence[page])
	set_visible_characters(0)
	set_process_input(true)

# Note: Godot seems to put a blank line at the end of the text file. Similar to C's termination character at the end of a string
func load_file(file):
	var f = File.new()
	f.open(file, File.READ)
	var index = 1
	while not f.eof_reached():
		textSequence.append(f.get_line())
	f.close()
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_F:
			if get_visible_characters() > get_total_character_count():
				if page < textSequence.size() - 1:
					page += 1
					set_bbcode(textSequence[page])
					set_visible_characters(0)
			else:
				set_visible_characters(get_total_character_count())

func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
