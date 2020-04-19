extends Area2D

onready var anim := $AnimationPlayer

func _ready() -> void:
	anim.play("default")

func _on_Energy_body_entered(body: Node) -> void:
	if (body.is_in_group("player")):
		body.energy += 5
		anim.play("collected")
		yield(anim, "animation_finished")
		queue_free()
