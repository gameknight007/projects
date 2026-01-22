extends Area2D

@onready var blackimage: ColorRect = $"../CanvasLayer/balckimage"


func _on_body_entered(body: Node2D) -> void:
	call_deferred("_reload")

func  _reload()-> void:
	Global.player_died = true
	Global._fade_in(blackimage)
	await get_tree().create_timer(0.5).timeout
	Global._fade_out(blackimage)
	Global._reload()
