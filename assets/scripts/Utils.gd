extends Node


static func get_child_of_class(parent : Node, classes):
	for child in get_all_children(parent):
		if !(classes is Array):
			if child is classes:
				return child
		else:
			for _class in classes:
				if child is _class:
					return child
	return null

static func get_child_in_groups(parent : Node, groups):
	## Get child in groups
	##
	## Get the first child found that is in one of the groups
	for child in get_all_children(parent):
		if typeof(groups) == TYPE_ARRAY:
			for group in groups:
				if child.is_in_group(group):
					return child
		else:
			if child.is_in_group(groups):
				return child
	return null

static func get_all_children(parent):
	var children = parent.get_children()
	var output = children.duplicate()

	for child in children:
		if child.get_child_count() > 0:
			output += get_all_children(child)
	
	return output

static func facing_to_num(facing : bool):
	return (int(facing) * 2) - 1
