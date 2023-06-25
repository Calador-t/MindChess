class_name Rambler

extends BasePiece

func _init():
	move_direction = []
	for x in [-1,0,1]:
		for y in [-1,0,1]:
			if x == 0 && y == 0:
				continue
			move_direction.append(Vector2(x,y))
