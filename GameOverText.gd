extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.game_over.connect(_display_game_over_text)
	Global.game_reset.connect(_hide_game_over_text)

func _display_game_over_text():
	visible = true

func _hide_game_over_text():
	visible = false
