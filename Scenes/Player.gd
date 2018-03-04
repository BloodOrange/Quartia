extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var nickname
var color

var controller = null setget set_controller

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_controller(ctrl):
	controller = ctrl
	for child in get_children():
		remove_child(child)
	add_child(ctrl)

func pick_piece():
	controller.pick_piece();

func play_piece(piece):
	controller.play_piece(piece)
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
