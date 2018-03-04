extends Area

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var main = get_node("/root/Main")

export (int) var identifiant

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func disable():
	$CollisionShape.disabled = true

func enable():
	$CollisionShape.disabled = false

func _on_Area_mouse_entered():
	if main.is_mode_playing():
		var mat = null
		if main.currentPlayer == Player1:
			mat = preload("res://Scenes/Board/BlueArea.tres")
		else:
			mat = preload("res://Scenes/Board/RedArea.tres")
		$CollisionShape/MeshInstance.mesh.material = mat
		$CollisionShape/MeshInstance.visible = true


func _on_Area_mouse_exited():
	if main.is_mode_playing():
		$CollisionShape/MeshInstance.visible = false


func _on_Area_input_event( camera, event, click_position, click_normal, shape_idx ):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT:
		if main.is_mode_playing():
			# On desactive toutes les zones
			get_tree().call_group("area", "disable")
			
			main.selected_area(self)
