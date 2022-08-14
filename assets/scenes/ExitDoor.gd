extends KinematicBody2D

signal exited(next_scene)

export(String, FILE, '*.tscn') var next_scene
export var open : = true

onready var sprite : = $AnimatedSprite
onready var detector : = $CopingArea2D

func _process(delta: float) -> void:
	$AnimatedSprite/LightIndicator.color = Color.green if open else Color.red
	
	if open:
		for body in detector.get_overlapping_bodies():
			if body.is_in_group('Player') and Input.is_action_just_pressed('interact'):
				var tween = get_tree().create_tween()
				tween.tween_property(body, 'modulate', Color.transparent, 0.75)
				tween.tween_callback(sprite, 'play', ['default', true])
				yield(tween, 'finished')
				
				emit_signal('exited', next_scene)

func _on_body_entered(body: Node) -> void:
	if open:
		if body.is_in_group('Player'):
			sprite.play('default')


func _on_body_exited(body: Node) -> void:
	if open:
		if body.is_in_group('Player'):
			sprite.play('default', true)


func _on_trigger(state : bool):
	open = state
