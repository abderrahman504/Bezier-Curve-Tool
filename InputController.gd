extends Node2D

signal left_click(pos: Vector2)
signal right_click()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			left_click.emit(get_global_mouse_position())
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			right_click.emit()
