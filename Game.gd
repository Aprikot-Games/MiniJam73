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
var g_score = 0

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
const LIVE_SIZE = Vector2(16, 16)

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
	show_menu_UI(false)
	g_current_level = Level.instance()
	add_child(g_current_level)
	g_current_level.connect("lose_live", self, "sub_live")
	update_score()

func deinit():
	show_general_UI(false)
	show_menu_UI(true)
	destroy_lives()
	g_current_level.queue_free()

# Hide or show the general UI, not considering notifications
func show_general_UI(val):
	if val == true:
		$UI/Score.show()
	else:
		$UI/Score.hide()
	show_lives(val)

func show_menu_UI(val):
	if val == true:
		$UI/StartButton.show()
		$UI/Background.show()
	else:
		$UI/StartButton.hide()
		$UI/Background.hide()

func show_lives(val):
	for live in gLives:
		if val == false:
			live.hide()
		else:
			live.show()

func set_initial_values():
	gLives_n = START_LIVES
	g_score = 0

func add_score():
	g_score += 1
	update_score()

func update_score():
	$UI/Score.text = str(g_score)

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

func _on_StartButton_pressed():
	set_state(state.SHOOT)
