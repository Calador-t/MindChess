class_name Main
extends Node2D

@onready var world_scene = preload("res://world.tscn")
var world: Node2D = null
func _on_play_button_down():
	world = world_scene.instantiate()
	world.main = self
	add_child(world)
	$CanvasLayer.visible = false
	
func game_lost():
	print("gamre sadasd")
	var go_timer = Timer.new()
	add_child(go_timer)
	go_timer.wait_time = 0.5
	go_timer.one_shot = true
	go_timer.timeout.connect(clear_game)
	go_timer.start()

func clear_game():
	print("cl ggg")
	if world:
		world.queue_free()
		world = null
	$CanvasLayer.visible = true
	if get_tree():
		get_tree().paused = false

func _on_close_button_down():
	get_tree().quit()
