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

var players = []

var currentPlayerId = 0

func _ready():
	# Hack pour lancer la scène seul
	Player1.nickname = "Jérémy"
	Player1.color = "#2980b9"
		
	Player2.nickname = "Mathilde"
	Player2.color = "#e74c3c"
	
	# Création du plateau
	for i in range(BOARD_SIZE):
		board.append([])
		board[i].append(null)
		board[i].append(null)
		board[i].append(null)
		board[i].append(null)
	
	# Ajout des joueurs
	players.append(Player1)
	players.append(Player2)
	update_text()

func change_player():
	currentPlayerId = (currentPlayerId + 1) % 2

func is_mode_selection():
	return mode == SELECTION

func is_mode_playing():
	return mode == PLAYING

func is_finish_game(lastX, lastY):
	var win = false
	
	# Test Horizontal
	var countColor = 0
	var countShape = 0
	var countSize = 0
	var countInside = 0
	
	var completeLine = true
	
	for x in range(0, BOARD_SIZE):
		if board[lastY][x] == null:
			completeLine = false
		else:
			countColor += board[lastY][x].color
			countShape += board[lastY][x].shape
			countSize += board[lastY][x].size
			countInside += board[lastY][x].inside
	
	if completeLine:
		win = countColor == BOARD_SIZE || countColor == 0 || \
			  countShape == BOARD_SIZE || countShape == 0 || \
			  countSize == BOARD_SIZE || countSize == 0 || \
			  countInside == BOARD_SIZE || countInside == 0
	
	if !win:
		# Test Vertical
		countColor = 0
		countShape = 0
		countSize = 0
		countInside = 0
		completeLine = true
		
		for y in range(0, BOARD_SIZE):
			if board[y][lastX] == null:
				completeLine = false
			else:
				countColor += board[y][lastX].color
				countShape += board[y][lastX].shape
				countSize += board[y][lastX].size
				countInside += board[y][lastX].inside
		
		if completeLine:
			win = countColor == BOARD_SIZE || countColor == 0 || \
			  countShape == BOARD_SIZE || countShape == 0 || \
			  countSize == BOARD_SIZE || countSize == 0 || \
			  countInside == BOARD_SIZE || countInside == 0

	if !win:
		# Test Diagonal \
		countColor = 0
		countShape = 0
		countSize = 0
		countInside = 0
		completeLine = true
		
		for i in range(0, BOARD_SIZE):
			if board[i][i] == null:
				completeLine = false
			else:
				countColor += board[i][i].color
				countShape += board[i][i].shape
				countSize += board[i][i].size
				countInside += board[i][i].inside
		
		if completeLine:
			win = countColor == BOARD_SIZE || countColor == 0 || \
			  countShape == BOARD_SIZE || countShape == 0 || \
			  countSize == BOARD_SIZE || countSize == 0 || \
			  countInside == BOARD_SIZE || countInside == 0
			
	if !win:
		# Test Diagonal /
		countColor = 0
		countShape = 0
		countSize = 0
		countInside = 0
		completeLine = true
		
		for i in range(0, BOARD_SIZE):
			var piece = board[i][BOARD_SIZE - i - 1]
			if piece == null:
				completeLine = false
			else:
				countColor += piece.color
				countShape += piece.shape
				countSize += piece.size
				countInside += piece.inside
		
		if completeLine:
			win = countColor == BOARD_SIZE || countColor == 0 || \
			  countShape == BOARD_SIZE || countShape == 0 || \
			  countSize == BOARD_SIZE || countSize == 0 || \
			  countInside == BOARD_SIZE || countInside == 0
	return win

func update_text():
	var text = "À [color=" + players[currentPlayerId].color + "]" + players[currentPlayerId].nickname + "[/color]"
	if mode == PLAYING:
		text += " de jouer la pièce"
	else:
		text += " de choisir une pièce"
	$MarginContainer/Label.clear()
	$MarginContainer/Label.append_bbcode(text)

func pick_piece(piece):
	pickedPiece = piece
	mode = PLAYING
	change_player()
	update_text()

func select_area(area):
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
		var text = "[color=" + players[currentPlayerId].color + "]" + players[currentPlayerId].nickname + "[/color]"
		text += " est l'heureux gagnant !"
		$MarginContainer/Label.clear()
		$MarginContainer/Label.append_bbcode(text)
		
		mode = END
	else:
		update_text()