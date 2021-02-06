extends Node2D

signal lose_live

export (PackedScene) var Enemy

func _ready():
	pass 

func _on_Player_player_lose_live():
	emit_signal("lose_live")
