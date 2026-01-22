extends Node


func _Displaynumbers(value : int, position : Vector2,color : Color) :
	var number = Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	number.label_settings.font_color = color
	number.label_settings.outline_color = Color.WHITE
	number.label_settings.font_size = 18
	number.label_settings.outline_size = 1
	
	call_deferred("add_child",number)
	await  number.resized
	number.pivot_offset = Vector2(number.size /2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number,"position:y",number.position.y - 24,0.25
	).set_ease(Tween.EASE_OUT)
	
	await  tween.finished
	
	number.queue_free()
	
func _Displayparticles(position : Vector2,color : Color):
	var particle = CPUParticles2D.new()
	particle.global_position = position
	particle.amount = 20
	particle.z_index = 5
	particle.emission_sphere_radius = 20.0
	particle.color = color
	
	call_deferred("add_child",particle)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
