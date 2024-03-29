extends Button
class_name ControlButton

signal button_down_w_index(idx: int)

func _ready():
	button_down.connect(on_button_down)

func on_button_down():
	button_down_w_index.emit(get_index()-1)
