class_name Knight

extends BasePiece

func _init():
	move_direction = []
	move_direction.append(Vector2(-1,-2))
	move_direction.append(Vector2(1,-2))
	move_direction.append(Vector2(-2,-1))
	move_direction.append(Vector2(2,-1))
	move_direction.append(Vector2(-2,1))
	move_direction.append(Vector2(2,1))
	move_direction.append(Vector2(-1,2))
	move_direction.append(Vector2(1,2))
