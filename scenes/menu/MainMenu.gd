extends Control

func _ready() -> void:
	$AnimationPlayer.play("default")
	for child in $ButtonsVBoxContainer.get_children():
		if child is Button:
			child.connect("mouse_entered", self, "play_button_sound")
			child.connect("pressed", self, "play_button_sound")

func play_button_sound():
	$ButtonSFX.play()


func _on_xDButton_pressed() -> void:
	$BG.play()


func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://scenes/maingame/MainGame.tscn")

func _on_HowButton_pressed() -> void:
	$HelpPopupDialog.popup()

func _on_HelpOKButton_pressed() -> void:
	$HelpPopupDialog.hide()


func _on_AboutOKButton_pressed() -> void:
	$AboutPopupDialog.hide()


func _on_AboutButton_pressed() -> void:
	$AboutPopupDialog.popup()


func _on_About_meta_clicked(meta) -> void:
	OS.shell_open(meta)
