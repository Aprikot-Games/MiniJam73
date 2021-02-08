extends Node2D

signal lose_live

export (PackedScene) var Enemy
var spawn_timeout = 1

func _ready():
	randomize()

func _on_Player_player_lose_live():
	emit_signal("lose_live")

func _on_SpawnTimer_timeout():
	var mob =  Enemy.instance()
	$MobPath/MobSpawnLocation.offset = randi()
	mob.position = $MobPath/MobSpawnLocation.position
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	#mob.rotation = direction
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	add_child(mob)
	mob.shoot()

func add_score():
	get_node("..").add_score()

func _on_DifficultyTimer_timeout():
	spawn_timeout = spawn_timeout / 1.5
	$ParallaxBackground.scroll_speed *= 1.5
	$SpawnTimer.wait_time = spawn_timeout
