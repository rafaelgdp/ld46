extends Node

signal points_updated(p)
signal hp_updated(v)
signal fruit_updated(f)

var points = 0 setget set_points
var pet = null
var fruit = 0
var main = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()

func set_points(p):
	points = p
	emit_signal("points_updated", p)

func on_pet_hp_updated(v):
	emit_signal("hp_updated", v)

var dmg_scene := preload("res://scenes/damage/DamageView.tscn")

func spawn_damage_at(pos, dmg):
	if (main != null):
		main.spawn_damage_at(pos, dmg)
