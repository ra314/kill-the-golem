extends KinematicBody2D

var motion = Vector2()
var rolling = false
var attacking = false
var stamina = 100
onready var anim = $AnimationTree.get("parameters/playback")

#Stats
var speed = 64
var rollSpeed = 192
var iframes = 1
var hp = 3
var defense = 1
var attack = 1



func _physics_process(delta):

	#Stamina Regen
	if stamina < 100:
		stamina += 0.2

	#Movement
	if rolling == false:
		if Input.is_action_pressed("ui_right"):
			motion.x = speed
			$Sprite.flip_h = false
			$Sword.flip_h = false
			$Camera2D.offset_h = lerp($Camera2D.offset_h, 0, 0.2)
			if attacking == false:
				anim.travel("Walk")
			else:
				anim.travel("AttackMoving")
		elif Input.is_action_pressed("ui_left"):
			motion.x = -speed
			$Sprite.flip_h = true
			$Sword.flip_h = true
			$Camera2D.offset_h = lerp($Camera2D.offset_h, -0.8, 0.2)
			if attacking == false:
				anim.travel("Walk")
			else:
				anim.travel("AttackMoving")
		else:
			motion.x = 0
			if attacking == false:
				anim.travel("Idle")
			else:
				anim.travel("AttackIdle")

	#Roll
	if Input.is_action_just_pressed("ui_z") and stamina >= 20:
		rolling = true
		stamina -= 20
		attacking = false
	if rolling == true:
		anim.travel("Roll")
		if $Sprite.flip_h == false:
			motion.x = rollSpeed
		else:
			motion.x = -rollSpeed
	
	#Attack
	if Input.is_action_just_pressed("ui_x"):
		attacking = true

	#Equipment
	$Sword.set_frame($Sprite.get_frame())
	
	move_and_slide(motion)
	print(stamina)
	
func rollOver():
	rolling = false
func attackOver():
	attacking = false
