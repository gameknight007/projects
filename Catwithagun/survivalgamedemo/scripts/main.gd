extends Node2D

@export var enemyscene : PackedScene
@onready var enemyspawnpath: PathFollow2D = $player/enemyspawnpath/PathFollow2D
@onready var gameover: Panel = $CanvasLayer2/Gameover
@onready var spawntimer: Timer = $spawntimer

func _ready() -> void:
	gameover.visible = false
	Engine.time_scale = 1.0
	spawntimer.start()

func spawn():
	enemyspawnpath.progress_ratio = randf()
	var enemy = enemyscene.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = enemyspawnpath.global_position

func _on_spawntimer_timeout() -> void:
	spawn()

func _on_player_health_depleted() -> void:
	gameover.visible = true
	Engine.time_scale = 0.0

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
