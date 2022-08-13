class_name CopingArea2D
extends Area2D

export(Array, NodePath) var shape_node_paths = []

func _ready() -> void:
	for path in shape_node_paths:
		var new_shape = get_node(path).duplicate()
		add_child(new_shape)
