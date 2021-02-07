extends Area2D

var speed = 550
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position -= transform.y * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.damage()
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
