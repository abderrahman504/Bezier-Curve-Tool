extends Control

var point_scene: PackedScene = preload("res://point.tscn")
var control_points: Array[Node2D] = []
var selected_point: int
@onready var control_button_cont = $SidePanel/MarginContainer/ScrollContainer/VBoxContainer
@onready var place_point_button = $SidePanel/MarginContainer/ScrollContainer/VBoxContainer/PlacePoint




func _ready():
	place_point_button.disabled = true
	selected_point = -1
	$InputController.left_click.connect(on_left_click)
	$InputController.right_click.connect(on_right_click)
	place_point_button.button_down.connect(on_place_point_button_pressed)

func on_left_click(pos: Vector2):
	if selected_point != -1:
		#Move point
		control_points[selected_point].position = pos
	else:
		#Create point
		var point_view: Node2D = point_scene.instantiate()
		add_child(point_view)
		point_view.position = pos
		control_points.append(point_view)
		point_view.get_node("Label").text = "P" + str(control_points.size()-1)
		#create control button
		add_control_button()
	#Send points to bezier processor
	var points: PackedVector2Array = PackedVector2Array()
	for x in control_points:
		points.append(x.position)
	$BezierProcessor.update(points)

func add_control_button():
	var control_button: Button = Button.new()
	control_button_cont.add_child(control_button)
	control_button.text = "P" + str(control_points.size()-1)
	control_button.button_down.connect(on_control_button_pressed.bind(control_points.size()-1))

func on_right_click():
	if control_points.size() == 0: return
	#Delete point
	selected_point = control_points.size()-1 if selected_point == -1 else selected_point
	delete_control_button(selected_point)
	remove_child(control_points[selected_point])
	control_points.remove_at(selected_point)
	selected_point = -1
	place_point_button.disabled = true
	#Send points to bezier processor
	var points: PackedVector2Array = PackedVector2Array()
	for x in control_points:
		points.append(x.position)
	$BezierProcessor.update(points)
	#Update labels on buttons and points
	refresh_all_point_labels()

func delete_control_button(idx: int):
	control_button_cont.remove_child(control_button_cont.get_children()[idx+1])
	

func on_control_button_pressed(idx: int):
	print("button for point " + str(idx) + " pressed")
	selected_point = idx
	control_button_cont.get_children()[idx+1].disabled = true
	place_point_button.disabled = false

func on_place_point_button_pressed():
	control_button_cont.get_children()[selected_point+1].disabled = false
	selected_point = -1
	place_point_button.disabled = true
	

func refresh_all_point_labels():
	var children: Array = control_button_cont.get_children()
	for i in range(control_points.size()):
		var b: Button = children[i+1]
		b.text = "P"+str(i)
		control_points[i].get_node("Label").text = "P"+str(i)

