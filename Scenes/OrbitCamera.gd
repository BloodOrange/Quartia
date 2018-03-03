extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var isTurningAround = false
var lastMousePosition = null

export (float) var rotationXMin = -PI / 2.0
export (float) var rotationXMax = 0.0
export (float) var zoomMin = 10.0
export (float) var zoomMax= 80.0

onready var CameraNode = $GimbalInner/Camera

func _ready():
	set_process_input(true)

func _input(event):
	#TODO: Utiliser un tween pour un déplacement pour naturel
	#TODO: Régler la sensibilité de la souris
	#TODO: Définir la sensibilité en fonction de la taille de la fenêtre
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			isTurningAround = event.is_pressed()
			if event.is_pressed():
				lastMousePosition = event.position
		elif event.button_index == BUTTON_WHEEL_UP and event.is_pressed():
			zoom(0.9)
		elif event.button_index == BUTTON_WHEEL_DOWN and event.is_pressed():
			zoom(1.1)
	elif event is InputEventMouseMotion:
		if isTurningAround:
			turnAround(event.position - lastMousePosition)
			lastMousePosition = event.position

func turnAround(delta):
	rotate_y(-delta.x / 100.0)
			
	var rotationX = $GimbalInner.rotation.x - delta.y / 100.0
	$GimbalInner.rotation.x = clamp(rotationX, rotationXMin, rotationXMax)

func zoom(delta):
	var translatedZ = CameraNode.translation.z * delta
	CameraNode.translation.z = clamp(translatedZ, zoomMin, zoomMax)