extends ProgressBar

func _ready() -> void:
	Game.connect("hp_updated", self, "on_hp_updated")

func on_hp_updated(v):
	value = v
