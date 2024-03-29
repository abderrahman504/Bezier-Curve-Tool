extends Node
class_name BezierProcessor

@onready var line: Line2D = $Line2D

func update(points: PackedVector2Array):
	line.clear_points()
	if (points.size() < 2): return
	var t: float = 0
	var n := points.size()-1
	while t <= 1:
		var p: Vector2 = Vector2.ZERO
		var c_nk = 1
		for k in range(n+1):
			p += points[k]*c_nk * pow(t, k) * pow(1-t, n-k)
			c_nk = c_nk * (n-k) / (k+1)
		line.add_point(p)
		t = t + 0.001
		print(t)
	
