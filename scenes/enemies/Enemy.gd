extends KinematicBody2D

var accel : float = 10
var target : KinematicBody2D = null
var speed = 20
var motion := Vector2.ZERO
var can_attack := true

const MAX_HP := 3
var hp := MAX_HP setget set_hp

onready var flip_nodes := $FlipNodes
onready var anim := $AnimationPlayer

func _ready() -> void:
	anim.play("walk")
	target = Game.pet
	$HPProgress.max_value = MAX_HP

func _physics_process(delta: float) -> void:
	
	if (target == null):
		target = Game.pet
	elif global_position.distance_to(target.global_position) > 30:
		var dir = (target.global_position - global_position).normalized()
		motion = dir * speed
		move_and_slide(motion)
		if anim.current_animation != "walk":
			anim.play("walk")
	elif can_attack:
		# Close enough to attack
		attack()
	
	if (motion.x < -0.1):
		flip(true)
	elif (motion.x > 0.1):
		flip(false)

func attack():
	can_attack = false
	if ($AttackArea.get_overlapping_areas().size() > 0):
		# If is near the target, damage it
		anim.play("attack")
		target.hurt(1)
		yield(anim, "animation_finished")
		anim.play("walk")
		$AttackCooldownTimer.start()

func flip(v):
	flip_nodes.scale.x = -1 if v else 1

func _on_AttackCooldownTimer_timeout() -> void:
	can_attack = true

func set_hp(v):
	hp = max(0, v)
	$HPProgress.value = hp
	if (hp <= 0):
		queue_free() # TODO: die animation

func hurt(dmg):
	self.hp -= dmg
