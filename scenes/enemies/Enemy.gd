extends KinematicBody2D

var accel : float = 10
var target : KinematicBody2D = null
var speed = 20
var base_damage = 5
var motion := Vector2.ZERO
var can_attack := true
var dead := false
var max_hp := 5
var hp := 5 setget set_hp
var level := 1
onready var flip_nodes := $FlipNodes
onready var anim := $AnimationPlayer

func _ready() -> void:
	set_it_up(level)

func set_it_up(level):
	max_hp = randi() % 10 + level + 2
	base_damage = max_hp - 2
	$HPProgress.max_value = max_hp
	self.hp = max_hp
	speed = min(max(20, rand_range(20, 35) - max_hp - base_damage), 100)
	anim.play("walk")
	target = Game.pet

func _physics_process(delta: float) -> void:
	if (target == null):
		target = Game.pet
	elif not dead and global_position.distance_to(target.global_position) > 30:
		var dir = (target.global_position - global_position).normalized()
		motion = dir * speed
		move_and_slide(motion)
		if anim.current_animation != "walk":
			anim.play("walk")
	elif can_attack and not dead:
		# Close enough to attack
		attack()
	
	if (motion.x < -0.1):
		flip(true)
	elif (motion.x > 0.1):
		flip(false)

func attack():
	can_attack = false
	if ($AttackArea.get_overlapping_areas().size() > 0 and not dead):
		# If is near the target, damage it
		anim.play("attack")
		target.hurt(base_damage)
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
	$HPProgress/Label.text = str(hp) + "/" + str(max_hp)
	if (hp <= 0):
		dead = true
		$Hurtbox/CollisionShape2D.set_deferred("disabled", true)
		$AttackArea/CollisionShape2D.set_deferred("disabled", true)
		$CollisionShape2D.set_deferred("disabled", true)
		speed = 5
		anim.play("die")

func hurt(dmg):
	$HurtSFX.play()
	self.hp -= dmg
	Game.points += 2 * dmg
	Game.spawn_damage_at(global_position, dmg)
