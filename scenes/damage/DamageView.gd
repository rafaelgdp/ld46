extends Node2D

var amount := 0 setget set_amount

func set_amount(v : int):
	amount = v
	$Label.text = str(v)
	
func play_anim():
	$AnimationPlayer.play("spawn")
	var t = Tween.new()
	add_child(t)
	t.interpolate_property(self, "position", position, position - Vector2(0, 8), 1, Tween.TRANS_LINEAR)
	t.start()
