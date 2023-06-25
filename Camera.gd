extends Camera2D

var zoom_speed: float = 0.05
var zoom_min: float = 0.2
var zoom_max: float = 2
var dragSensitivity: float = 1.0


func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("Drag camera"):
		position -= event.relative * dragSensitivity / zoom
	
	if event is InputEventMouseButton:
		var zoom_temp = zoom
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_temp += Vector2(zoom_speed, zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN: 
			zoom_temp -= Vector2(zoom_speed, zoom_speed)
		zoom = clamp(zoom_temp, Vector2(zoom_min, zoom_min), Vector2(zoom_max, zoom_max))

