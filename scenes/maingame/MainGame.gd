extends Node2D

func _on_Pet_pet_died() -> void:
	get_tree().paused = true

func _on_HUD_restart_game() -> void:
	get_tree().reload_current_scene()
