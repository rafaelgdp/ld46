extends "res://scenes/pet/Fruit.gd"

func _ready() -> void:
	Game.connect("fruit_updated", self, "update_fruit")

func update_fruit(f):
	self.fruit = f

func _physics_process(delta: float) -> void:
	if(fruit != Game.fruit):
		self.fruit = Game.fruit


func _on_HUD_restart_game() -> void:
	fruit = null
