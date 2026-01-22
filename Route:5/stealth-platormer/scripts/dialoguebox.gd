extends MarginContainer

@onready var letterdisplaytimer: Timer = $letterdisplaytimer
@onready var label: Label = $MarginContainer/Label
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

const  MAX_WIDTH : float = 256.0

var text : String = ""
var letter_index : int = 0
var letter_time : float = 0.08
var space_time : float = 0.08
var punch_timer : float = 0.08

signal finished_displaying

func _displaytext(text_to_display : String)-> void :
	text = text_to_display
	label.text = text_to_display
	await resized
	custom_minimum_size.x = min(size.x,MAX_WIDTH)
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	global_position.x -= size.x / 2
	global_position.y -= size.y /2
	label.text = ""
	_displayletter()

func _displayletter()-> void:
	audio_stream_player.play()
	audio_stream_player.pitch_scale = randf_range(0.7,1.1)
	label.text += text[letter_index]
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
	match text[letter_index]:
		"!",".","?",",":
			letterdisplaytimer.start(punch_timer)
		" " :
			letterdisplaytimer.start(space_time)
		_:
			letterdisplaytimer.start(letter_time)


func _on_letterdisplaytimer_timeout() -> void:
	_displayletter()
