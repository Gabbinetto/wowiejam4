extends TextureButton

signal level_sent(path)

export var level = 1
var needed_completed_levels = level - 1
var level_path = 'res://assets/scenes/levels/level_' + str(level) + '.tscn'

func _ready() -> void:
	$Number.text = str(level)
	connect('level_sent', owner, '_on_level_sent')

func _process(delta: float) -> void:
	disabled = Globals.completed_levels < needed_completed_levels

func _on_button_up() -> void:
	emit_signal('level_sent', level_path)
