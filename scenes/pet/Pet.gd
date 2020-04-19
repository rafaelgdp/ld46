extends KinematicBody2D

signal pet_died
signal pet_hp_updated(v)

var check_fruits := false
var point_increment := 10
var hp := 100 setget set_hp

onready var iarea := $InteractiveArea2D
onready var my_fruit := $DialogPanel/Fruit
onready var dialog_anim := $DialogAnimationPlayer
onready var hurt_anim = $HurtAnim

func _ready() -> void:
	self.hp = 100
	dialog_anim.play("show_food")
	connect("pet_hp_updated", Game, "on_pet_hp_updated")
	Game.pet = self
	Game.fruit = my_fruit.fruit

func _on_InteractiveArea2D_area_entered(area: Area2D) -> void:
	self.check_fruits = true

func _on_InteractiveArea2D_area_exited(area: Area2D) -> void:
	if (iarea.get_overlapping_areas().size() == 0):
		self.check_fruits = false

func _process(delta: float) -> void:
	if check_fruits:
		var fruits = iarea.get_overlapping_areas()
		for fa in fruits:
			var fruit = fa.get_parent()
			if fruit.is_in_group("pickable_fruit"):
				if fruit.fruit == my_fruit.fruit:
					fruit.eat()
					Game.points += point_increment
					self.hp += 5
					my_fruit.choose_new()
					Game.fruit = my_fruit.fruit
					$YummySound.play()
				else:
					var point = Vector2.ONE.rotated(rand_range(0, 2 * PI)) * rand_range(50, 80)
					point += global_position
					if (fruit.throw_to(point)):
						$YuckSound.play()

func hurt(dmg):
	self.hp -= dmg
	hurt_anim.play("hurt")

func set_hp(v):
	if (v <= 0):
		emit_signal("pet_died")
	hp = min(max(0, v), 100)
	emit_signal("pet_hp_updated", v)

func _on_StarveTimer_timeout() -> void:
	self.hp -= 1
