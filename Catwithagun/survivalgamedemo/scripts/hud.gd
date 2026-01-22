extends Control

@export var heartsize = 32
@onready var hearts: TextureRect = $hearts
@onready var maxhearts: TextureRect = $maxhearts
@onready var player: CharacterBody2D = $"../.."

func _ready() -> void:
	maxhearts.size.x = player.maxhealth * heartsize
	
func _on_player_healthchanged(playerhearts) -> void:
	hearts.size.x = heartsize * playerhearts
