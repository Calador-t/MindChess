extends Node2D

var controled_piece

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			var click_pos = Con.world_to_grid(get_global_mouse_position())
			GObj.world.toggle_enemy_info(click_pos)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var click_pos = Con.world_to_grid(get_global_mouse_position())
			GObj.world.move_player_piece(click_pos)
