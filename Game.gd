extends Node2D

export (PackedScene) var Live
export (PackedScene) var Level

# Constants
const START_LIVES = 3
const START_LEVEL = 0

# Globals
enum state {START, SHOOT, OVER}
var gGame_state = state.START
var gLives_n = 0
var gLives = []
var gLevel = START_LEVEL
var g_current_level = null

func _ready():
	$UI/Msg.text = ""
	$UI/Msg.hide()

func _process(delta):
	# Check for Lose condition
	if gGame_state == state.SHOOT:
		if gLives_n == 0:
			set_state(state.OVER)

func set_state(new_state):
	if new_state == gGame_state:
		# Can't set existing states
		return
	if new_state == state.START:
		print("Setting Start")
		deinit()
	elif new_state == state.SHOOT:
		if gGame_state != state.START:
			# Must wait for START state
			return
		print("Setting SHOOT")
		init()
	elif new_state == state.OVER:
		show_general_UI(false)
		set_notification("GAME OVER")
		$OverTimer.start()
	else:
		print("Invalid state argument")
	gGame_state = new_state

func generate_lives():
	for i in range(0, gLives_n):
		var live = Live.instance()
		add_child(live)
		gLives.append(live)

func destroy_lives():
	for live in gLives:
		live.queue_free()
	gLives = []

func sub_live():
	if gLives_n > 0:
		gLives_n -= 1
	update_lives()

func add_live():
	if gLives_n < START_LIVES:
		gLives_n += 1
	update_lives()

#---------   USER INTERFACE
const LIVE_MARGIN = Vector2(10, 10)
const LIVE_SIZE = Vector2(10, 10)

func position_lives():
	for i in range(0, START_LIVES):
		gLives[i].position.x = LIVE_MARGIN.x + (LIVE_SIZE.x * i)
		gLives[i].position.y = LIVE_MARGIN.y

# Remove or add lives according to the lives number
func update_lives():
	if gLives == []:
		return
	for i in range(0, START_LIVES):
		if (i <= gLives_n-1):
			gLives[i].show()
		else:
			gLives[i].hide()

func init():
	set_initial_values()
	generate_lives()
	position_lives()
	show_general_UI(true)
	g_current_level = Level.instance()
	add_child(g_current_level)
	g_current_level.connect("lose_live", self, "sub_live")

func deinit():
	show_general_UI(false)
	destroy_lives()
	g_current_level.queue_free()

# Hide or show the general UI, not considering notifications
func show_general_UI(val):
	show_lives(val)

func show_lives(val):
	for live in gLives:
		if val == false:
			live.hide()
		else:
			live.show()

func set_initial_values():
	gLives_n = START_LIVES

func _on_Timer_timeout():
	set_state(state.START)

func set_notification(msg):
	$UI/Msg.text = msg
	$UI/Msg.show()
	$NotifyTimer.start()

func _on_NotifyTimer_timeout():
	$UI/Msg.text = ""
	$UI/Msg.hide()

func _on_Startb_pressed():
	set_state(state.START)

func _on_Overb_pressed():
	set_state(state.OVER)

func _on_Shootb_pressed():
	set_state(state.SHOOT)

func _on_SubLiveb_pressed():
	sub_live()

func _on_AddLiveb_pressed():
	add_live()
