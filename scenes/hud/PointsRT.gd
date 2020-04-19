extends RichTextLabel

func _ready() -> void:
	Game.connect("points_updated", self, "on_points_updated")

func on_points_updated(p):
	bbcode_text = "Points: " + str(p)
