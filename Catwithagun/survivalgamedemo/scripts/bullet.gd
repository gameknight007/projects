extends Area2D

var travelleddistance = 0.0
var SPEED = 0
var RANGE = 0

var damage = 0.0

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelleddistance += SPEED * delta
	if travelleddistance > RANGE :
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	var direction = global_position.direction_to(body.global_position)
	var knockbackforce = direction.normalized() * 1900
	if body.has_method("_Gothit"):
		body.bullet_hit = true
		body._Gothit(damage,knockbackforce)
	queue_free()
