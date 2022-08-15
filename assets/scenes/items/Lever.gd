extends Item

export var sideways : = false
export var inverted_signal : = false
export(Array, NodePath) var connected_items

var time_since_last_activation : = 500

onready var sprite : = $AnimatedSprite
onready var detector : = $Detector

func _ready() -> void:
	for path in connected_items:
		connect('triggered', get_node(path), '_on_triggered')

func _process(delta: float) -> void:
	sprite.animation = 'Ground' if sideways else 'Background'
	sprite.frame = int(active)

func _physics_process(delta: float) -> void:
	var bodies = detector.get_overlapping_bodies()
	for body in bodies:
		if (body.is_in_group('Player') or body.is_in_group('Body')) and Input.is_action_just_pressed('interact'):
			if time_since_last_activation >= 20:
				time_since_last_activation = 0
				active = !active
				if !inverted_signal:
					emit_signal('triggered', active)
				else:
					emit_signal('triggered', !active)
			print(time_since_last_activation)
	time_since_last_activation += 1
