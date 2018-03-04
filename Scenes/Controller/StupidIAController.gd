extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var t

func _ready():
	t = Timer.new()
	t.wait_time = 1
	t.one_shot = true
	add_child(t)

func pick_piece():
	var Main = get_node("/root/Main")
	t.start()
	yield(t, "timeout")
	var pieces = get_tree().get_nodes_in_group("pieces")
	Main.picked_piece(pieces[0])

func play_piece(piece):
	var Main = get_node("/root/Main")
	t.start()
	yield(t, "timeout")
	var areas = get_tree().get_nodes_in_group("area")
	Main.selected_area(areas[0])
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
