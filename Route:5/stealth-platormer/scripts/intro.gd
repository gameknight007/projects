extends Control

const lines : Array[String] = [
	"Log 1 :  item collected  , 
	returning to base,
	route 7 blocked,
	choosing alternate route,route 5 !"
]

@onready var marker_2d: Marker2D = $Marker2D
@onready var label: Label = $Label
@onready var label_2: Label = $Label2


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	label_2.modulate.a = 0
	label.modulate.a = 0
	Dialoguemanager.finished.connect(_intro_over)
	await get_tree().create_timer(0.5).timeout
	Global._fade_in(label_2)
	await get_tree().create_timer(1.5).timeout
	Global._fade_out(label_2)
	await get_tree().process_frame
	await get_tree().create_timer(1.0).timeout
	_start_intro()

func _start_intro()-> void:
	Dialoguemanager._start_dialogue(marker_2d.global_position,lines)

func _intro_over():
	Global._fade_in(label)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("advance"):
		print("intro_over")
		Dialoguemanager.dialogueactive = false
		Dialoguemanager.textbox.queue_free()
		Global._fade_out(label)
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/level_1.tscn")
