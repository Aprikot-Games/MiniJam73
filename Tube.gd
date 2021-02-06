extends Node2D

var content = [0,0,0,0,0,0]
var level = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	pass

func _draw():
	for i in range(0, level):
		draw_circle(Vector2(0, i*(12)), 10, Color.green)

func put(color):
	if level < 6:
		content[level] = color
		level += 1
		self.update()

func pop(color):
	if level > 0:
		level -= 1
		return content[level]
		self.update()
