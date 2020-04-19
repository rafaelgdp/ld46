extends Sprite

export var number_fruits := 5
var fruit = 0 setget set_fruit

func _ready() -> void:
	hframes = number_fruits
	choose_new()

func choose_new():
	self.fruit = randi() % number_fruits

func set_fruit(v):
	fruit = v
	frame = v
