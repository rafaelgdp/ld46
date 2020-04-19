extends "res://scenes/pet/Fruit.gd"

var pickable := false setget set_pickable
var picked := false setget set_picked
onready var anim := $AnimationPlayer
onready var sfx := $SFX
onready var collision := $Area2D/CollisionShape2D
onready var tt := $ThrowTween

func set_picked(v : bool):
	collision.disabled = v
	picked = v

func set_pickable(v : bool):
	pickable = v
	glow(v)

func glow(v):
	if (not decaying):
		if (v):
			anim.play("pickable")
			modulate = Color(2, 2, 2, 1)
		else:
			anim.play("still")
			modulate = Color(1, 1, 1, 1)

func _on_Area2D_area_entered(area: Area2D) -> void:
	if (area.is_in_group("player")):
		sfx.play()
		self.pickable = true

func _on_Area2D_area_exited(area: Area2D) -> void:
	if (area.is_in_group("player")):
		self.pickable = false

func picked_by(hand):
	self.picked = true
	get_parent().remove_child(self)
	hand.add_child(self)
	position = Vector2.ZERO

func dropped_at(pos):
	global_position = pos
	self.picked = false

func eat():
	queue_free()

var throwing = false
func throw_to(point):
	if not throwing:
		pickable = false
		throwing = true
		tt.interpolate_property(self, "global_position", global_position, point, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tt.start()
		tt.connect("tween_all_completed", self, "on_throw_completed")
		return true
	return false
	
func on_throw_completed():
	throwing = false

var decaying = false
func _on_DecayTimer_timeout() -> void:
	if (not picked and not throwing):
		decaying = true
		$Area2D/CollisionShape2D.disabled = true
		anim.play("decay")
		yield(anim, "animation_finished")
		queue_free()
	else:
		$DecayTimer.start()
