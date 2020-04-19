extends Control

signal restart_game

func _on_Pet_pet_died() -> void:
	$GameOverDialog.popup()

func _on_RestartButton_pressed() -> void:
	get_tree().paused = false
	emit_signal("restart_game")


func _on_PlayerRobot_update_energy(e) -> void:
	$StatusPanel/EnergyLabel.text = "Energy: " + str(e)
