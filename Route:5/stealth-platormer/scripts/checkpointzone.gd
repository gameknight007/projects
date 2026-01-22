extends Area2D

@export var animationplayer : AnimationPlayer
@export var animname : String

@export var lines : Array[String] = []
var triggered = false

func _on_body_entered(body: Node2D) -> void:
	Global.player_newpos = global_position
	if body.is_in_group("player") and triggered == false:
		triggered = true
		Global.game_on = false
		Dialoguemanager._start_dialogue(global_position,lines)
		await Dialoguemanager.finished
		if animname != "":
			animationplayer.play(animname)
		else:
			Global.game_on = true
