extends Area2D

func _process(delta: float) -> void:
	update()

func _draw():
	draw_circle(Vector2.ZERO, 50, Color(0.1, 1, 0.1, 0.1))

func _on_DamageTimer_timeout() -> void:
	for area in get_overlapping_areas():
		var body = area.get_parent()
		if (body.is_in_group("enemy")):
			body.hurt((randi() % 5) + 2)


func _on_HealTimer_timeout() -> void:
	for area in get_overlapping_areas():
		var body = area.get_parent()
		if body.is_in_group("pet"):
			body.heal((randi() % 5) + 5)

func _on_DecayTimer_timeout() -> void:
	call_deferred("queue_free")
