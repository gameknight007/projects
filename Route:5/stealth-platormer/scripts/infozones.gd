extends Area2D

@export var inputkeyname : Array[String] = []
@export var keybind : Array[String] = []

@export var  triggured = false

@onready var inputsprite: AnimatedSprite2D = $inputsprite

func _ready() -> void:
	inputsprite.hide()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not triggured:
		Global.player_newpos = global_position
		inputsprite.show()
		triggured = true
		inputsprite.play(inputkeyname[0])

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed(keybind[0]) and triggured:
		if inputkeyname.size() > 1 :
			inputsprite.play(inputkeyname[1])
		else:
			inputsprite.hide()
			return
	if keybind.size() > 1 and  Input.is_action_pressed(keybind[1]):
		inputsprite.hide()
