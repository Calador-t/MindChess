class_name World

extends Node2D


const SPAWN_EVER_TICK: int = 1

@onready var white_tile = preload("res://Art/White.png")
@onready var black_tile = preload("res://Art/Black.png")
@onready var pieces_scenes = [	preload("res://Piece/rambler.tscn"), 
								preload("res://Piece/knight.tscn"),
								preload("res://Piece/Tower.tscn"),
					   			]

var main: Main = null
var destroyed_pieces = 0
@export var __player_piece: Node2D = null
var __active_enemy_piece: BasePiece = null:
	set(new_val):
		if __active_enemy_piece:
			__active_enemy_piece.enemy_deativate()
		
		__active_enemy_piece = new_val
		
		if __active_enemy_piece:
			__active_enemy_piece.enemy_active()
	get:
		return __active_enemy_piece

var tick_number = 0
var board = {}
var pieces = {}


func _init():
	GObj.world = self
	
	for x in Con.BOARD_SIZE:
		for y in Con.BOARD_SIZE:
			board[Vector2(x,y)] = null

func _ready():
	$CanvasLayer/Label.text = ""
	for x in Con.BOARD_SIZE:
		for y in Con.BOARD_SIZE:
			var texture = white_tile

			if (x+y) % 2 == 0:
				texture = black_tile
				
			board[Vector2(x,y)] = Helper.spawn_sprite(Vector2(x,y), texture, $Board)
	
	if __player_piece:
		set_player_piece(__player_piece)
	__activate_random_enemy()

func __tick():
	$PieceInfo.hide_enemy_info()
	tick_number += 1
	
	var player_hit: bool = false
	
	for enemy in pieces.values():
		if enemy == __player_piece:
			continue
		if enemy.hit_player(__player_piece.pos):
			player_hit = true
			break
	if !player_hit && __active_enemy_piece:
		__active_enemy_piece.tick(__player_piece.pos)
	
	if tick_number % SPAWN_EVER_TICK == SPAWN_EVER_TICK - 1:
		spawn_enemy()
	__activate_random_enemy()


func spawn_enemy():
	var spawn_pos = randi() % Con.BOARD_SIZE
	
	var piece_scene = pieces_scenes.pick_random()
	
	var piece = piece_scene.instantiate()
	piece.position = Con.grid_to_world(Vector2(spawn_pos,0))
	$Pieces.add_child(piece)

func get_piece_pos(pos: Vector2) -> BasePiece:
	if pieces.has(pos):
		return pieces[pos]
	return null

func add_piece(pos: Vector2, piece: BasePiece):
	# unvalid position 
	if !board.has(pos):
		printerr("Piece: " + str(piece) + " can't be place on pos: " + str(pos))
		piece.queue_free()
		return
	if pieces.has(pos):
		pieces[pos].queue_free()
	
	pieces[pos] = piece

func player_move_to(to_pos: Vector2, piece: BasePiece) -> BasePiece:
	if !__pre_move_piece(to_pos, piece):
		return null
	
	# is there an piece on goal field?
	if pieces.has(to_pos):
		if pieces[to_pos] == __active_enemy_piece:
			print("lol")
			
			__active_enemy_piece = null
		
		set_player_piece(pieces[to_pos])
		piece.queue_free()
		return
	
	pieces[to_pos] = piece
	piece.set_pos(to_pos)
	return piece

func ai_move_to(to_pos: Vector2, piece: BasePiece) -> bool:
	if !__pre_move_piece(to_pos, piece):
		return false
	
	if pieces.has(to_pos):
		pieces[to_pos].queue_free()
		pieces[to_pos] = piece
	else:
		pieces[to_pos] = piece
	
	piece.set_pos(to_pos)
	return true

func __pre_move_piece(to_pos: Vector2, piece: BasePiece) -> bool:
	if !piece:
		return false
	if !board.has(to_pos):
		return false

	if pieces.has(piece.pos) && pieces[piece.pos] == piece:
		pieces.erase(piece.pos)
	else:
		printerr("Should add piece: " + str(piece) + " before moving")
	return true

# moves a piece to a filed
# returns true if succesfull
func move_to(to_pos: Vector2, piece: BasePiece):
	if !piece:
		return
	
	if piece == __player_piece:
		player_move_to(to_pos, piece)
	else:
		ai_move_to(to_pos, piece)
	return

func has_tile(pos: Vector2) -> bool:
	if board.has(pos):
		return true
	return false

func toggle_enemy_info(pos: Vector2):
	var piece = get_piece_pos(pos)
	if piece && piece != __player_piece:
		$PieceInfo.show_enemy_info(piece)
	else:
		$PieceInfo.hide_enemy_info()
	pass

func hide_enemy_info():
	if !$Pieces/PieceInfo:
		return
	$Pieces/PieceInfo.hide_enemy_info()

func move_player_piece(to_pos: Vector2):
	if __player_piece && __player_piece.can_move_to(to_pos):
		__player_piece.move_to(to_pos)
		show_player_paths()
		__tick()


func show_player_paths():
	if __player_piece:
		$PieceInfo.show_player_info(__player_piece)

func set_player_piece(piece: BasePiece):
	if !piece:
		return
	__player_piece = piece
	show_player_paths()

func player_piece_deleted(piece: BasePiece):
	if piece != __player_piece:
		return
	__player_piece = null
	if !$PieceInfo:
		return
	$PieceInfo.hide_player_info()
	if $CanvasLayer/Label2:
		$CanvasLayer/Label2.visible = true
	if main:
		main.game_lost()
	if get_tree():
		get_tree().paused = true
	
	

func __activate_random_enemy():
	var random_key = pieces.keys()[randi() % pieces.size()]
	var piece = pieces[random_key]
	
	if piece == __player_piece:
		if pieces.size() > 1:
			__activate_random_enemy()
		return
	
	__active_enemy_piece = piece

func is_palyer_piece(piece: BasePiece):
	return piece == __player_piece

func piece_destroyed():
	destroyed_pieces += 1
	if $CanvasLayer:
		$CanvasLayer/Label.text = str(destroyed_pieces)
