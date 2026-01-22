extends Node2D

@onready var cinecamera: Camera2D = $cinecamera
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var blackimage: ColorRect = $CanvasLayer/balckimage
@onready var bg: AudioStreamPlayer = $bg
@onready var backgroundnoises: AudioStreamPlayer = $backgroundnoises
@onready var randomizer: Timer = $randomizer
@onready var gameoverwindow: Panel = $CanvasLayer/gameoverwindow
@onready var continuelabel: Label = $CanvasLayer/continuelabel
@onready var tutorial_1: Panel = $CanvasLayer/tutorial_1
@onready var tutorial_2: Panel = $CanvasLayer/tutorial_2

func _ready() -> void:
	Global.blackpanel = blackimage
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	tutorial_1.hide()
	tutorial_2.hide()
	continuelabel.hide()
	gameoverwindow.hide()
	_fadeinandout()
	animation_player.play("begin")
	bg.play()
	Global.game_on = false
	randomizer.start(10.0)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("advance") and Dialoguemanager.dialogueactive:
			continuelabel.hide()
	if Dialoguemanager.dialogueactive:
		if Input.is_action_pressed("jump") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("run"):
			_ondialogueactiveandkeypressed()

func _beginend()-> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Global.game_on = true

func _intro_end()-> void:
	Global.game_on = true

func _end()-> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Global.gameover = true
	gameoverwindow.show()
	print("gameover")

func _fadeinandout():
	Global._fade_in(blackimage)
	await get_tree().create_timer(0.5).timeout
	Global._fade_out(blackimage)

func _on_randomizer_timeout() -> void:
	backgroundnoises.volume_db = randf_range(0.7,1.2)
	backgroundnoises.pitch_scale = randf_range(0.8,1.2)
	backgroundnoises.play()
	randomizer.start(randf_range(16.0,25.0))

func _on_button_pressed() -> void:
	get_tree().quit()

func _ondialogueactiveandkeypressed()-> void :
	if Dialoguemanager.dialogueactive:
		continuelabel.show()
		Global._fade_in(continuelabel)
		await get_tree().process_frame
		Global._fade_out(continuelabel)

func _on_closebutton_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	tutorial_1.hide()

func _on_closebutton_2_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	tutorial_2.hide()
