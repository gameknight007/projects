extends Area2D

@onready var label: Label = $Label

func _ready() -> void:
	label.hide()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.show()
		body.in_noise_reduct_zone = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		label.hide()
		body.in_noise_reduct_zone = false
