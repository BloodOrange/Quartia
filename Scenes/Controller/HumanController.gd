extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func pick_piece():
	get_tree().call_group("pieces", "enable")
	

func play_piece(piece):
	get_tree().call_group("area", "enable")
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
