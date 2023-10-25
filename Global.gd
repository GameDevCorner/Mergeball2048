extends Node

var score = 0
var game_running = true

signal score_updated
signal game_over
signal game_reset

func _ready():
	game_over.connect(_stop)
	game_reset.connect(_reset)

func update_score(point):
	if game_running:
		score += point
		score_updated.emit()

func _stop():
	game_running = false
	#print("Game Over")
	pass

func _reset():
	game_running = true
	update_score(-score)
	#print("Game Reset")
	pass
