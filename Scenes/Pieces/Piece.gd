extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (String) var pieceName
export (int, "Black", "White") var color
export (int, "Round", "Square") var shape
export (int, "Hollow", "Filled") var inside
export (int, "Tall", "Small") var size

onready var main = get_node("/root/Main")

func _ready():
	add_to_group("pieces")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func disable():
	$Area/CollisionShape.disabled = true

func enable():
	$Area/Area/CollisionShape.disabled = false

func _on_Area_mouse_entered():
	$MeshInstance.rotate_x(0.3141592)


func _on_Area_mouse_exited():
	$MeshInstance.rotate_x(-0.3141592)


func _on_Area_input_event( camera, event, click_position, click_normal, shape_idx ):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		if main.is_mode_selection():
			disable()
			scale *= 2.0
			main.pick_piece(self)
