extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

enum Mode {
	SELECTION,
	PLAYING,
	END
};

const BOARD_SIZE = 4

var mode = SELECTION

var pickedPiece = null
var board = []

var currentPlayer = null

class CountProperty:
	var color = 0
	var shape = 0
	var size = 0
	var inside = 0
	var nbManagedPieces = 0

	func manage_piece(piece):
		color += piece.color
		shape += piece.shape
		size += piece.size
		inside += piece.inside
		nbManagedPieces += 1
	
	func is_win():
		return (nbManagedPieces == 4) && (color == 0 || color == 4 || shape == 0 || shape == 4 || size == 0 || size == 4 || inside == 0 || inside == 4)
		
func _ready():	
	# Création du plateau
	for i in range(BOARD_SIZE):
		board.append([])
		board[i].append(null)
		board[i].append(null)
		board[i].append(null)
		board[i].append(null)
	
	currentPlayer = Player1
	update_text()

func next_player():
	if currentPlayer == Player1:
		currentPlayer = Player2
	else:
		currentPlayer = Player1

func is_mode_selection():
	return mode == SELECTION

func is_mode_playing():
	return mode == PLAYING

func is_finish_game(lastX, lastY):
	var horizontalCounter = CountProperty.new()
	var verticalCounter = CountProperty.new()
	var diagCounter = CountProperty.new()
	var invDiagCounter = CountProperty.new()
	
	for i in range(0, BOARD_SIZE):
		var horPiece = board[lastY][i]
		var vertPiece = board[i][lastX]
		var diagPiece = board[i][i]
		var invDiagPiece = board[i][BOARD_SIZE - i - 1]
		
		if horPiece != null:
			horizontalCounter.manage_piece(horPiece)
		if vertPiece != null:
			verticalCounter.manage_piece(vertPiece)
		if diagPiece != null:
			diagCounter.manage_piece(diagPiece)
		if invDiagPiece != null:
			invDiagCounter.manage_piece(invDiagPiece)
	
	return horizontalCounter.is_win() || verticalCounter.is_win() || diagCounter.is_win() || invDiagCounter.is_win()

func update_text():
	var text = "À [color=" + currentPlayer.color + "]" + currentPlayer.nickname + "[/color]"
	if mode == PLAYING:
		text += " de jouer la pièce"
	else:
		text += " de choisir une pièce"
	$MarginContainer/Label.clear()
	$MarginContainer/Label.append_bbcode(text)

func picked_piece(piece):
	# On ne pourrait plus jouer cette pièce
	piece.remove_from_group("pieces")
	
	piece.scale *= 2.0
	pickedPiece = piece
	mode = PLAYING
	next_player()
	update_text()
	
	currentPlayer.play_piece(piece)

func selected_area(area):
	# On ne peut plus jouer sur cette case
	#$CollisionShape/MeshInstance.visible = false
	area.get_node("CollisionShape/MeshInstance").visible = false
	area.remove_from_group("area")

	var trans = pickedPiece.global_transform
	var relTrans = pickedPiece.translation
	pickedPiece.get_parent().remove_child(pickedPiece)
	area.add_child(pickedPiece)
	pickedPiece.global_transform = trans
	
	relTrans.x = 0.0
	relTrans.z = 0.0
	relTrans.y += 2.0
	
	var animTime = 1.0
	
	$Tween.interpolate_property(pickedPiece, "translation", pickedPiece.translation, relTrans, animTime, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.interpolate_property(pickedPiece, "rotation_degrees", pickedPiece.rotation_degrees, Vector3(0.0, 0.0, 0.0), animTime, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.interpolate_property(pickedPiece, "scale", pickedPiece.scale, Vector3(1.0, 1.0, 1.0), animTime, Tween.TRANS_EXPO, Tween.EASE_OUT)
	
	var finalTrans = relTrans
	finalTrans.y -= 2.0
	$Tween.interpolate_property(pickedPiece, "translation", relTrans, finalTrans, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT, 0.5)
	
	$Tween.start()
	
	var x = area.identifiant % BOARD_SIZE
	var y = area.identifiant / BOARD_SIZE
	board[y][x] = pickedPiece
	pickedPiece = null
	mode = SELECTION
	
	if is_finish_game(x, y):
		var text = "[color=" + currentPlayer.color + "]" + currentPlayer.nickname + "[/color]"
		text += " est l'heureux gagnant !"
		$MarginContainer/Label.clear()
		$MarginContainer/Label.append_bbcode(text)
		
		mode = END
	else:
		update_text()
		currentPlayer.pick_piece()
