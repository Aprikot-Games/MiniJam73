extends KinematicBody2D

signal player_lose_live

enum state {MOVE, GHOST}

var g_current_state = state.MOVE
var g_motion = Vector2.ZERO

const ACCELERATION = 1000
const MAX_SPEED = 200
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
		g_motion.x = clamp(g_motion.x, -MAX_SPEED, MAX_SPEED)
		# Change the sprite animation according to the input direction
		if x_input < 0 and g_current_state == state.MOVE:
			$Ship.animation = "Lean"
		if x_input > 0 and g_current_state == state.MOVE:
			#$Ship.transform = -1
			$Ship.animation = "Lean"
	elif x_input == 0:
		if g_current_state == state.MOVE:
			$Ship.animation = "Idle"
		g_motion.x = lerp(g_motion.x, 0, FRICTION)
	if y_input != 0:
		# Move the damn thing
		g_motion.y += y_input * ACCELERATION * delta
		g_motion.y = clamp(g_motion.y, -MAX_SPEED, MAX_SPEED)
	elif y_input == 0:
		g_motion.y = lerp(g_motion.y, 0, FRICTION)
	g_motion = move_and_slide(g_motion)
	
	if  get_slide_count() > 0 and g_current_state == state.MOVE:
		g_current_state = state.GHOST
		$RespawnTimer.start()
		$CollisionShape.disabled = true
		$Ship.play("Ghost")
		emit_signal("player_lose_live")

func _on_RespawnTimer_timeout():
	g_current_state = state.MOVE
	$Ship.animation = "Idle"
	$CollisionShape.disabled = false