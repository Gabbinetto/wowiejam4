extends Label

export(float, 0.001, 4096) var time_between_characters = 0.05
export var delay : = 2.0
var ready_to_type = false

func _ready() -> void:
	set_visible_characters(0)
	$Timer.wait_time = time_between_characters
	yield(owner, 'ready')
	yield(get_tree().create_timer(delay), 'timeout')
	ready_to_type = true



func _on_timeout() -> void:
	set_visible_characters(visible_characters + 1 * int(ready_to_type))
