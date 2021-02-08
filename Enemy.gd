extends Node2D

enum state {MOVE, DEAD}
var g_current_state = state.MOVE

export (PackedScene) var Bullet
var min_speed = 20
var max_speed = 60

func _ready():
	$Ship.play("Idle")

func _on_Enemy_body_entered(body):
	damage()

func damage():
	$Boom.play()
	g_current_state = state.DEAD
	var parent = get_node("..")
	parent.add_score()
	$CollisionShape2D.set_deferred("disabled", true)
	$Ship.play("Explosion")
	yield($Ship, "animation_finished")
	queue_free()

func shoot():
	if g_current_state == state.MOVE:
		var bullet = Bullet.instance()
		var parent = get_node("..")
		if parent != null:
			parent.add_child(bullet)
			bullet.transform = self.global_transform
			bullet.position.y += 10

func _on_ShootCD_timeout():
	shoot()

func _on_VisibilityNotifier2D_screen_exited():
	#get_node("..").mobCounter -= 1
	queue_free()
