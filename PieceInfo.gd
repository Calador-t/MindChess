extends Node2D

@onready var enemy_range = preload("res://Art/Read.png")
@onready var player_range = preload("res://Art/Yellow.png")

var __focused_enemy = null


func hide_enemy_info():
	remove_childs($EnemyPieceInfo)

func show_enemy_info(piece: BasePiece):
	hide_enemy_info()
	__focused_enemy = piece
	for tile_pos in piece.all_next_pos():
		if GObj.world.has_tile(tile_pos):
			Helper.spawn_sprite(tile_pos, enemy_range, $EnemyPieceInfo)

func hide_player_info():
	remove_childs($NextPlayerSteps)

func show_player_info(piece: BasePiece):
	hide_player_info()
	for tile_pos in piece.all_next_pos():
		if GObj.world.has_tile(tile_pos):
			Helper.spawn_sprite(tile_pos, player_range, $NextPlayerSteps)


func remove_childs(parent: Node2D):
	var all_children = parent.get_children()
	for child in all_children:
		parent.remove_child(child)
		child.queue_free()
