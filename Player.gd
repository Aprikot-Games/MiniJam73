extends KinematicBody2D

export (PackedScene) var Bullet

signal player_lose_live

enum state {MOVE, GHOST}

var g_current_state = state.MOVE
var g_motion = Vector2.ZERO

const ACCELERATION = 1500
const MAX_SPEED = 200
const BRAKE_SPEED = 80
const FRICTION = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") \
				  - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") \
				  - Input.get_action_strength("ui_up")
	if x_input != 0:
		# Move the damn thing
		g_motion.x += x_input * ACCELERATION * delta
		if Input.is_action_pressed("ui_brake"):
			g_motion.x = clamp(g_motion.x, -BRAKE_SPEED, BRAKE_SPEED)
		else:
			g_motion.x = clamp(g_motion.x, -MAX_SPEED, MAX_SPEED)
		# Change the sprite animation according to the input direction
		if x_input < 0 and g_current_state == state.MOVE:
			$Ship.play("Left")
		if x_input > 0 and g_current_state == state.MOVE:
			#$Ship.transform = -1
			$Ship.play("Right")
	elif x_input == 0:
		if g_current_state == state.MOVE:
			$Ship.play("Idle")
		g_motion.x = lerp(g_motion.x, 0, FRICTION)
	if y_input != 0:
		# Move the damn thing
		g_motion.y += y_input * ACCELERATION * delta
		if Input.is_action_pressed("ui_brake"):
			g_motion.y = clamp(g_motion.y, -BRAKE_SPEED, BRAKE_SPEED)
		else:
			g_motion.y = clamp(g_motion.y, -MAX_SPEED, MAX_SPEED)
	elif y_input == 0:
		g_motion.y = lerp(g_motion.y, 0, FRICTION)
	g_motion = move_and_slide(g_motion, Vector2(0,0), false, 4, 0.785398, false)
	position.x = clamp(position.x, 0, get_viewport().size.x/2)
	position.y = clamp(position.y, 0, get_viewport().size.y/2)
	
	if  get_slide_count() > 0:
		damage()
	
	if Input.is_action_just_pressed("ui_shoot"):
		shoot()

func damage():
	if g_current_state == state.MOVE:
		g_current_state = state.GHOST
		$Alert.play()
		$RespawnTimer.start()
		$CollisionShape.set_deferred("disabled", true)
		$Ship.play("Ghost")
		emit_signal("player_lose_live")

func shoot():
	$Shoot.play()
	var left_bullet = Bullet.instance()
	var right_bullet = Bullet.instance()
	owner.add_child(left_bullet)
	owner.add_child(right_bullet)
	left_bullet.transform = self.global_transform
	right_bullet.transform = self.global_transform
	left_bullet.position.y -= 15
	right_bullet.position.y -= 15
	left_bullet.position.x -= 6
	right_bullet.position.x += 6

func _on_RespawnTimer_timeout():
	g_current_state = state.MOVE
	$Alert.stop()
	$Ship.animation = "Idle"
	$CollisionShape.set_deferred("disabled", false)
