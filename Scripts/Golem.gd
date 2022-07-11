extends KinematicBody2D

var velocity = Vector2()
var hp := 10
var vulnerable := true
onready var anim = $AnimationTree.get("parameters/playback")
onready var knight = get_parent().get_node("Knight")

func _physics_process(delta):
	check_collision()

func walk():
	anim.travel("Walk")

func check_hurt():
	if vulnerable:
		if knight.can_damage:
			hp-=1
			print(hp)
			vulnerable = false
			$Timer.start()

func check_collision():
	var body = $Area2D.get_overlapping_areas()
	for element in body:
		if element.name == "Area2D":
			check_hurt()

func punch() -> void:
	anim.travel("Punch")

func _on_Timer_timeout():
	vulnerable = true # iframes over
