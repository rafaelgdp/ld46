extends KinematicBody2D

signal update_energy(e)

var speed = 100
var motion = Vector2.ZERO

onready var sprite = $Body
onready var pick_sound = $PickSFX
onready var hands := $Body/Hands
onready var grab_pos := $Body/Hands/GrabPos
onready var drop_pos := $Body/Hands/DropPos
onready var anim := $AnimationPlayer

var hand_empty := true
var energy := 0 setget set_energy

var blast_scene := preload("res://scenes/powerups/EnergyBlast.tscn")

func _physics_process(delta: float) -> void:
	handle_motion()
	flip()
	if motion.length() < 0.1:
		anim.play("still")
	elif not anim.is_playing() or not anim.current_animation == "walking":
		anim.play("walking")
	motion = move_and_slide(motion)
	
func handle_motion():
	motion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	motion.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	motion = motion.normalized() * speed

func flip():
	if (motion.x > 0):
		sprite.scale.x = 1
	elif (motion.x < 0):
		sprite.scale.x = -1

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("pick")):
		pick_sound.play()
		if (hand_empty):
			var fruits = hands.get_overlapping_areas()
			if fruits.size() > 0:
				var p = fruits[0].get_parent()
				pick(fruits[0].get_parent())
		else:
			release()
	
	if (event.is_action_pressed("shoot")):
		if (energy > 0):
			shoot()

func pick(fruit):
	if fruit.is_in_group("pickable_fruit"):
		fruit.picked_by(grab_pos)
		hand_empty = false

func release():
	hand_empty = true
	var fruit = grab_pos.get_child(0)
	grab_pos.remove_child(fruit)
	get_parent().add_child(fruit)
	fruit.dropped_at(drop_pos.global_position)

func set_energy(e):
	energy = max(min(e, 100), 0)
	emit_signal("update_energy", energy)

func shoot():
	self.energy -= 1
	var dir = sign(sprite.scale.x)
	var blast = blast_scene.instance()
	blast.global_position = hands.global_position
	blast.direction = dir
	get_parent().add_child(blast)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
