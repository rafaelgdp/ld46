extends WindowDialog

onready var audio := $AudioStreamPlayer

func _on_GameOverDialog_about_to_show() -> void:
	audio.play()
	$Label.text = """Oh, boy! You let your pet die! Be more careful next time!
Points achieved: """ + str(Game.points)
