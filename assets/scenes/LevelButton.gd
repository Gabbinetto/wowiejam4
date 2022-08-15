extends TextureButton

signal level_sent(path)

export var level = 1
onready var level_path = 'res://assets/scenes/levels/level_' + str(level) + '.tscn'
onready var needed_completed_level = level - 1

func _ready() -> void:
	$Number.text = str(level)
	connect('level_sent', owner, '_on_level_sent')

func _process(delta: float) -> void:
	disabled = !Globals.completed_levels[needed_completed_level]

func _on_button_up() -> void:
	emit_signal('level_sent', level_path)
