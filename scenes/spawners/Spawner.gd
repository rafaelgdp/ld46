extends Node2D

export (PackedScene) var spawn_scene = preload("res://scenes/fruits/PickableFruit.tscn")

onready var spawn_centers := $SpawnCenters
onready var spawns := $Spawns
export (int, 10, 400) var spread = 50
export (float) var spawn_cooldown = 1

func _ready():
	$SpawnTimer.wait_time = spawn_cooldown

func _specialized_prep(_inst):
	pass

func spawn():
	var inst = spawn_scene.instance()
	var points = spawn_centers.get_children()
	if points.empty():
		points.global_position = random_pos(Vector2.ZERO)
	else:
		var i = randi() % points.size()
		inst.global_position = random_pos(points[i].global_position)
	_specialized_prep(inst)
	spawns.add_child(inst)
func random_pos(center):
	var pos = center
	pos.x += rand_range(-spread, spread)
	pos.y += rand_range(-spread, spread)
	return pos

func _on_SpawnTimer_timeout() -> void:
	spawn()
