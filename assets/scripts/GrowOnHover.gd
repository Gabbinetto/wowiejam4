extends Control

enum TransitionTypes {
	LINEAR = 0, SINE = 1, ELASTIC = 6, BOUNCE = 9, BACK = 10
}

enum EaseTypes {
	EASE_IN, EASE_OUT, EASE_IN_OUT, EASE_OUT_IN, NONE
}

export var node_to_scale : NodePath
export var node2d : = true
export var scale_modifier : = Vector2(2, 2)
export(TransitionTypes) var transition_type
export(EaseTypes) var ease_type
export var grow_time : float = 0.5

onready var node : = get_node(node_to_scale)
var property = 'rect_scale' if !node2d else 'scale'
var base_scale : Vector2

func _ready() -> void:
	base_scale = node.scale if node2d else node.rect_scale

func _on_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	if ease_type != EaseTypes.NONE:
		tween.tween_property(node, property, base_scale * scale_modifier, grow_time).set_trans(transition_type).set_ease(ease_type)
	else:
		tween.tween_property(node, property, base_scale * scale_modifier, grow_time).set_trans(transition_type)
	
func _on_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	if ease_type != EaseTypes.NONE:
		tween.tween_property(node, property, base_scale, grow_time).set_trans(transition_type).set_ease(ease_type)
	else:
		tween.tween_property(node, property, base_scale, grow_time).set_trans(transition_type)


