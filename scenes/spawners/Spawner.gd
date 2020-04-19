extends Node2D

signal spawned(n)

var num_spawns := 0 setget set_ns
export var spawn_number := 1 setget set_sn
export var max_spawns := 100
var spawn_level = 1

export (PackedScene) var spawn_scene = preload("res://scenes/fruits/PickableFruit.tscn")

onready var spawn_centers := $SpawnCenters
onready var spawns := $Spawns
export (int, 10, 400) var spread = 50
export (float) var spawn_cooldown = 10 setget set_sc

func set_sn(v):
	if (v % 10 == 0):
		spawn_level += 3
	spawn_number = min(25, v)

func set_ns(v):
	num_spawns = v
	emit_signal("spawned", num_spawns)

func set_sc(v):
	spawn_cooldown = v if v > 1 else 1
	$SpawnTimer.wait_time = spawn_cooldown

func _ready():
	$SpawnTimer.wait_time = spawn_cooldown

func _specialized_prep(inst):
	if inst.is_in_group("enemy"):
		inst.level = spawn_level

func spawn():
	for n in range(spawn_number):
		if ($Spawns.get_child_count() > max_spawns):
			break
		var inst = spawn_scene.instance()
		var points = spawn_centers.get_children()
		if points.empty():
			points.global_position = random_pos(Vector2.ZERO)
		else:
			var i = randi() % points.size()
			inst.global_position = random_pos(points[i].global_position)
		_specialized_prep(inst)
		spawns.add_child(inst)
		self.num_spawns += 1

func random_pos(center):
	var pos = center
	pos.x += rand_range(-spread, spread)
	pos.y += rand_range(-spread, spread)
	return pos

func _on_SpawnTimer_timeout() -> void:
	spawn()
