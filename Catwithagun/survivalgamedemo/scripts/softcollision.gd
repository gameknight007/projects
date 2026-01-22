extends Area2D

func _is_colliding():
	var areas = get_overlapping_areas()
	return areas.size() > 0
	
func _get_push_vector():
	var areas = get_overlapping_areas()
	var pushvector = Vector2.ZERO
	if _is_colliding() :
		var area = areas[0]
		pushvector = area.global_position.direction_to(global_position)
		pushvector = pushvector.normalized()
	return pushvector
