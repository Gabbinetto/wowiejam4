extends Item

export var inverted_signal : = false
export var stay_active : = false
export(Array, NodePath) var connected_items

onready var area : = $Area2D

func _ready() -> void:
	active = false

	for path in connected_items:
		connect('triggered', get_node(path), '_on_triggered')


func _physics_process(delta: float) -> void:
	var bodies = area.get_overlapping_bodies()
	
	$ButtonHead.position.y = 0 if active else -3
	var light_color = Color.green if active else Color.red
	$LightIndicator.color = light_color
	$LightIndicator/LightIndicatorShadow.color = light_color



func _on_body_entered(body: Node) -> void:
	if body.is_in_group('Player') or body.is_in_group('Crate') or body.is_in_group('Head'):
		set_active(true)


func _on_body_exited(body: Node) -> void:
	if stay_active or (area.get_overlapping_bodies().size() > 1):
		return
		
	if body.is_in_group('Player') or body.is_in_group('Crate') or body.is_in_group('Head'):
		set_active(false)

func set_active(val):
	active = val
	emit_signal('triggered', !active if inverted_signal else active)
