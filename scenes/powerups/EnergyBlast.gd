extends Area2D

var direction := 1 # X direction
export var base_speed = 125

func _physics_process(delta: float) -> void:
	global_position += Vector2(direction, 0) * base_speed * delta

func _on_DecayTimer_timeout() -> void:
	queue_free()

func _on_EnergyBlast_area_entered(area: Area2D) -> void:
	var enemy = area.get_parent()
	if (enemy.is_in_group("enemy")):
		base_speed = 0
		enemy.hurt((randi() % 2) + 1)
		$AnimationPlayer.play("explode")
