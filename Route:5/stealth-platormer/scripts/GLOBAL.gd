extends Node

signal horn_on
signal horn_off

var game_on : bool = false
var player_died : bool = false
var player_newpos : Vector2 = Vector2.ZERO
var player : CharacterBody2D
var gameover : bool = false
var blackpanel : ColorRect

func _fade_in(item : Control)-> void:
	var tween = get_tree().create_tween()
	item.modulate.a = 0.0
	tween.set_parallel(true)
	tween.tween_property(item,"modulate:a",1,0.5).set_ease(Tween.EASE_OUT)
	

func _fade_out(item : Control)-> void:
	var tween = get_tree().create_tween()
	item.modulate.a = 255.0
	tween.set_parallel(true)
	tween.tween_property(item,"modulate:a",0,0.5).set_ease(Tween.EASE_OUT)

func _reload():
	if player_died :
		_fade_in(blackpanel)
		player.global_position = player_newpos
		player_died = false
		_fade_out(blackpanel)
