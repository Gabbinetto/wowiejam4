class_name Level
extends Node2D

export var transition_color : = Color('#d5d5d5')
const Transition = preload('res://assets/scenes/Transition.tscn')
var transition : Node
var trans_animator : AnimationPlayer

func _ready() -> void:
	transition = Transition.instance()
	trans_animator = transition.get_node('AnimationPlayer')
	transition.color = transition_color
	add_child(transition)
	yield(get_tree(), 'idle_frame')
	yield(get_tree().create_timer(.2), 'timeout')
	trans_animator.play('ExitToBottom')


func _on_door_exited(next_scene : String) -> void:
	trans_animator.play('ComeFromTop')
	yield(trans_animator, 'animation_finished')
	get_tree().change_scene(next_scene)
