extends Node

func spawn_sprite(pos: Vector2, texture, parent: Node2D):
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.position = Con.grid_to_world(pos)
	parent.add_child(sprite)
	return sprite
