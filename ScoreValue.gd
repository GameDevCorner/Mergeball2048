extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.score_updated.connect(update_score_text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_score_text():
	text = str(Global.score)
