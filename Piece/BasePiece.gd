class_name BasePiece

extends Node2D

var move_direction: Array[Vector2] = []
var pos: Vector2

func _ready():
	pos = Con.world_to_grid(position)
	position = Con.grid_to_world(pos)
	GObj.world.add_piece(pos, self)

func tick(player_pos: Vector2):
	if is_queued_for_deletion():
		return
	var direction: Vector2 = get_direciton_to_player(player_pos)
	if direction == Vector2.INF:
		return
	move_to(pos + direction)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if GObj.world.is_palyer_piece(self):
			GObj.world.player_piece_deleted(self)
		GObj.world.piece_destroyed()

func enemy_active():
	modulate= Color(30, 0, 0,1)

func enemy_deativate():
	modulate= Color(1, 1, 1,1)

func move_to(to_pos: Vector2):
	GObj.world.move_to(to_pos, self)

func set_pos(new_pos: Vector2):
	pos = new_pos
	position = Con.grid_to_world(pos)


# if posible kils the player if not don't move
func hit_player(player_pos: Vector2) -> bool:
	for direction in move_direction:
		if pos + direction == player_pos:
			move_to(pos + direction)
			return true
	return false

func get_direciton_to_player(player_pos: Vector2) -> Vector2:
	var direction: Vector2 = Vector2(0,0)
	var distance: float = INF
	for element in move_direction:
		var new_distance = (player_pos - (pos + element)).length()
		if new_distance < distance:

			distance = new_distance
			direction = element
	
	return direction

func get_valid_direction() -> Vector2:
	if move_direction.size() == 0:
		return Vector2.INF
	# Try random 2 times
	for i in 2:
		var test_direction = move_direction.pick_random()
		if GObj.world.has_tile(pos + test_direction):
			return test_direction
	# if not found in 2 random just go trough array
	for element in move_direction:
		if GObj.world.has_tile(pos + element):
			return element
	return Vector2.INF 

func all_next_pos() -> Array[Vector2]:
	var next_pos: Array[Vector2] = []
	for direction in move_direction:
		next_pos.append(pos + direction)
	return next_pos

func can_move_to(to_pos: Vector2) -> bool:
	for direction in move_direction:
		if pos + direction == to_pos:
			return true
	return false
