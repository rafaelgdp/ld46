extends Node2D

onready var enemy_spawner := $EnemySpawner
var dmg_scene := preload("res://scenes/damage/DamageView.tscn")

func _ready() -> void:
	Game.main = self
	Game.points = 0

func _on_Pet_pet_died() -> void:
	get_tree().paused = true

func _on_HUD_restart_game() -> void:
	get_tree().reload_current_scene()

func _on_EnemySpawner_spawned(n) -> void:
	if (n % 10 == 0):
		enemy_spawner.spawn_cooldown -= 0.001
		enemy_spawner.spawn_number += 1

func spawn_damage_at(pos, dmg):
	var d = dmg_scene.instance()
	d.amount = dmg
	add_child(d)
	d.position = pos
	d.play_anim()
