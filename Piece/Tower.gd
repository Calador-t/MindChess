class_name Tower

extends BasePiece

func _init():
	move_direction = [Vector2(0,1)]

func hit_player(player_pos: Vector2) -> bool:
	if pos.x == player_pos.x || pos.y == player_pos.y:
		if player_pos == pos:
			return false
		move_to(player_pos)
		return true
	return false

func get_direciton_to_player(player_pos: Vector2) -> Vector2:
	if pos.x == player_pos.x || pos.y == player_pos.y:
		if player_pos == pos:
			return Vector2.INF
		return player_pos - pos
	var same_y = randi() % 2 == 0
	var new_pos
	if same_y:
		new_pos = Vector2(player_pos.x, pos.y)
	else:
		new_pos = Vector2(pos.x, player_pos.y)
	return new_pos - pos


func all_next_pos() -> Array[Vector2]:
	var next_pos: Array[Vector2] = []
	var y = 0
	while GObj.world.has_tile(Vector2(pos.x, y)):
		if y != pos.y:
			next_pos.append(Vector2(pos.x, y))
		y += 1
	
	var x = 0
	while GObj.world.has_tile(Vector2(x, pos.y)):
		if x != pos.x:
			next_pos.append(Vector2(x, pos.y))
		x += 1
	
	return next_pos

func can_move_to(to_pos: Vector2) -> bool:
	if pos.x == to_pos.x || pos.y == to_pos.y:
		if to_pos == pos:
			return false
		return true
	return false
