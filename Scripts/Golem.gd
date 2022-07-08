extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var gay = $AnimationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	gay.travel("Fall")
func fallen():
	gay.travel("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
