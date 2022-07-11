extends KinematicBody2D

var velocity := Vector2()
var is_rolling := false
var is_attacking := false
var can_damage = false
var stamina := 100.0
var attacks_left := 0
onready var anim = $AnimationTree.get("parameters/playback")

# Stats
var speed := 64
var roll_speed := 192
var iframes := 1
var hp := 3
var defense := 1
var attack := 1
const STAMINA_NEEDED_FOR_ROLL := 20

func _physics_process(delta):
	regen_stamina()

	# Movement
	if !is_rolling:
		if Input.is_action_pressed("ui_right"):
			move(true) # Move Right
		elif Input.is_action_pressed("ui_left"):
			move(false) # Move Left 
		else:
			idle()

	# Roll
	if Input.is_action_just_pressed("ui_z"):
		try_to_roll()
	if is_rolling:
		move_in_rolling_direction()

	# Attack
	if Input.is_action_just_pressed("ui_x"):
		is_attacking = true
		attacks_left = 1

	# Equipment
	$Sword.set_frame($Sprite.get_frame())
	
	move_and_slide(velocity)

# Stamina Regen
func regen_stamina() -> void:
	if stamina < 100:
		stamina += 0.2

func move_in_rolling_direction() -> void:
	if !$Sprite.flip_h:
		velocity.x = roll_speed
	else:
		velocity.x = -roll_speed

func try_to_roll() -> void:
	if stamina >= STAMINA_NEEDED_FOR_ROLL:
		is_rolling = true
		stamina -= STAMINA_NEEDED_FOR_ROLL
		is_attacking = false
		anim.travel("Roll")

func finish_rolling() -> void:
	is_rolling = false

func finish_attacking() -> void:
	is_attacking = false
	can_damage = false
	attacks_left = 0
	
func attack_active():
	can_damage = true

func move(move_right: bool) -> void:
	if move_right:
		velocity.x = speed
		$Camera2D.offset_h = lerp($Camera2D.offset_h, 0, 0.2)
		get_node("Area2D/Swordhitbox").position.x = 26
		get_node("Area2D/Swordhitbox").position.y = 25
	else:
		velocity.x = -speed
		$Camera2D.offset_h = lerp($Camera2D.offset_h, -0.8, 0.2)
		get_node("Area2D/Swordhitbox").position.x = 8
		get_node("Area2D/Swordhitbox").position.y = 25
	$Sprite.flip_h = !move_right
	$Sword.flip_h = !move_right
	if !is_attacking:
		anim.travel("Walk")
	else:
		anim.travel("AttackMoving")

func idle() -> void:
	velocity.x = 0
	if !is_attacking:
		anim.travel("Idle")
	else:
		anim.travel("AttackIdle")
