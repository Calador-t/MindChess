extends Node

# ---- Board Data ----

const CELL_SIZE: int = 128
const BOARD_SIZE: int = 10

func grid_to_world(_pos: Vector2):
	return _pos * CELL_SIZE

func world_to_grid(_pos: Vector2):
	return floor(_pos / CELL_SIZE)

# ---- ... ----
