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
var energy := 100 setget set_energy
var max_energy := 999
var can_shoot := true

var blast_scene := preload("res://scenes/powerups/EnergyBlast.tscn")
var special_scene := preload("res://scenes/powerups/SpecialDamage.tscn")
var ultimate_scene := preload("res://scenes/powerups/Ultimate.tscn")

func _ready() -> void:
	emit_signal("update_energy", energy)

func _physics_process(delta: float) -> void:
	handle_motion()
	flip()
	if (Input.is_action_pressed("shoot") and can_shoot):
		if (energy > 0):
			shoot()
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
	
	if (event.is_action_pressed("special") and can_shoot):
		if (energy >= 10):
			special()

	if (event.is_action_pressed("ultimate") and can_shoot):
		if (energy >= 100):
			ultimate()
	
	if (event.is_action_pressed("speed_up") and can_shoot):
		if (energy >= 30):
			speed_up()

func speed_up():
	speed = 150
	self.energy -= 50
	$SpeedUpTimer.start()
	$SpeedUpParticles.emitting = true
	$SpeedUpSFX.play()

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
	energy = max(min(e, max_energy), 0)
	emit_signal("update_energy", energy)

func shoot():
	can_shoot = false
	$BlastCooldownTimer.start()
	self.energy -= 1
	$BlastSFX.play()
	var dir = sign(sprite.scale.x)
	var blast = blast_scene.instance()
	blast.global_position = hands.global_position
	blast.direction = dir
	get_parent().add_child(blast)
	
func special():
	can_shoot = false
	self.energy -= 10
	$SpecialSFX.play()
	var blast = special_scene.instance()
	blast.global_position = hands.global_position
	get_parent().add_child(blast)

func ultimate():
	can_shoot = false
	self.energy -= 100
	$SpecialSFX.play()
	var blast = ultimate_scene.instance()
	blast.global_position = hands.global_position
	get_parent().add_child(blast)

func _on_BlastCooldownTimer_timeout() -> void:
	can_shoot = true

func _on_SpeedUpTimer_timeout() -> void:
	speed = 100
	$SpeedUpParticles.emitting = false
