extends Node2D
export (PackedScene) var Tube

var tubes = []
# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_tubes()

func initialize_tubes():
	for i in range(0, 3):
		tubes.append(Tube.instance())
		add_child(tubes[i])
		tubes[i].position.x = 50 + i * 50
		tubes[i].position.y = 50

func _on_Button_pressed():
	tubes[0].put(2)
