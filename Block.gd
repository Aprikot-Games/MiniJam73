extends Sprite

var color = 0

var blue_tex = preload("res://sprites/Blue Piece.png")
var green_tex = preload("res://sprites/Green Piece.png")
var lemon_tex = preload("res://sprites/Light Green Piece.png")
var orange_tex = preload("res://sprites/Orange Piece.png")
var pink_tex = preload("res://sprites/Pink Piece 3.png")
var purple_tex = preload("res://sprites/Pink Piece.png")
var yellow_tex = preload("res://sprites/Yellow Piece.png")

var block_texs = [orange_tex, purple_tex, blue_tex,
green_tex, yellow_tex,pink_tex, lemon_tex]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_color(new_color):
	color = new_color
	self.set_texture(block_texs[color])

