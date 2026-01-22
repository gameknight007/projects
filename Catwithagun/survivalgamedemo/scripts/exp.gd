extends Area2D

@onready var amount  = 1
@onready var collected: AudioStreamPlayer = $COLLECTED
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("new_animation")


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("_addexp"):
		var direction = body.global_position
		var tween = create_tween()
		tween.tween_property(self,"position",direction,0.5).set_ease(Tween.EASE_IN)
		body._addexp(amount)
		collected.play()
		

func _on_collected_finished() -> void:
	queue_free()
