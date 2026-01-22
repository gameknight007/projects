extends Node

@onready var textboxscene = preload("res://scenes/dialoguebox.tscn")

var dialoguelines : Array[String] = []
var current_lineindex = 0

var textbox 
var textbox_position : Vector2
var dialogueactive : bool = false
var can_advance : bool = false

signal finished

func _start_dialogue(pos : Vector2,lines : Array[String])-> void:
	if dialogueactive:
		return
	dialoguelines = lines
	textbox_position = pos
	_showtextbox()
	dialogueactive = true

func _showtextbox()-> void:
	textbox = textboxscene.instantiate()
	textbox.finished_displaying.connect(_on_textfinihsed_displying)
	get_tree().root.add_child(textbox)
	textbox.global_position = textbox_position
	textbox._displaytext(dialoguelines[current_lineindex])
	can_advance = false

func _on_textfinihsed_displying()-> void:
	can_advance = true
	finished.emit()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("advance") and dialogueactive and can_advance:
		textbox.queue_free()
		current_lineindex += 1
		if current_lineindex >= dialoguelines.size():
			textbox.queue_free()
			dialogueactive = false
			current_lineindex = 0
			return
		_showtextbox()
