extends Area2D

var hurt_enemies = []

func _process(delta: float) -> void:
	for a in get_overlapping_areas():
		var enemy = a.get_parent()
		if (enemy.is_in_group("enemy") and not enemy in hurt_enemies):
			enemy.hurt((randi() % 4) + 3)
			hurt_enemies.append(enemy)
	update()


var color = Color(0, 0.5, 0.5, 0.5)
onready var tween := $DecayTween
func _ready() -> void:
	tween.interpolate_property(self, "color", color, Color(0, 1, 1, 0), 1, Tween.TRANS_LINEAR)
	tween.start()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 42, color)

func _on_DecayTimer_timeout() -> void:
	queue_free()
