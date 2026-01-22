extends Node2D

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var turnofftimer: Timer = $turnofftimer
@onready var turnontimer: Timer = $turnontimer



func _on_timer_timeout() -> void:
	if Global.gameover :
		audio.playing = false
		turnofftimer.stop()
		turnontimer.stop()
		return
	audio.playing = true
	turnontimer.start()
	Global.horn_on.emit()

func _on_turnontimer_timeout() -> void:
	if Global.gameover :
		audio.playing = false
		turnofftimer.stop()
		turnontimer.stop()
		return
	audio.playing = false
	turnofftimer.start(10)
	Global.horn_off.emit()

func _start():
	turnofftimer.start(0.2)
