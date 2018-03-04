extends MarginContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var name1 = get_node("VBoxContainer/GridContainer/Name1")
onready var name2 = get_node("VBoxContainer/GridContainer/Name2")

var startingCount = 5

var HumanController = null
var StupidController = null
 
func _ready():
	name1.grab_focus()
	HumanController = preload("res://Scenes/Controller/HumanController.gd")
	StupidController = preload("res://Scenes/Controller/StupidIAController.gd")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_BtnBegin_pressed():
	if name1.text.length() != 0 and name2.text.length() != 0:
		Player1.nickname = name1.text
		Player1.color = "#2980b9"
		Player1.controller = HumanController.new()
		
		Player2.nickname = name2.text
		Player2.color = "#e74c3c"
		Player2.controller = StupidController.new()
		
		show_counter()
		$VBoxContainer/BtnBegin.disabled = true
		
		begin_game()
		#$Timer.start()

func begin_game():
	$Timer.stop()
	$VBoxContainer/BtnBegin.text = "Démarrage..."
	get_tree().change_scene("res://Scenes/Main.tscn")

func show_counter():
	$VBoxContainer/BtnBegin.text = "Début de la partie dans " + str(startingCount) + "s"

func _on_Timer_timeout():
	startingCount -= 1
	if startingCount == 0:
		begin_game()
	else:
		show_counter()
