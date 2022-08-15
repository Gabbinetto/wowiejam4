extends Item

export var size : = Vector2(8, 8)
export var speed : = 20.0
export var delay : = 0.0
onready var path_follow : PathFollow2D = get_parent()
onready var path : Path2D = path_follow.get_parent()
onready var tween = $Tween
var starting_point : Vector2
var ending_point : Vector2

func _ready() -> void:
	assert(path_follow is PathFollow2D)
	assert(path is Path2D)

	$NinePatchRect.rect_size = size
	$CollisionShape2D.polygon = PoolVector2Array([
		Vector2(0, 0),
		Vector2(size.x, 0),
		size,
		Vector2(0, size.y)
	])

	path_follow.unit_offset = 1
	ending_point = path_follow.global_position
	
	path_follow.unit_offset = 0
	starting_point = path_follow.global_position
	global_position = path_follow.global_position



func _on_triggered(trigger):
	active = trigger
	play_trigger()
	var p = (global_position - (ending_point if active else starting_point)).length()
	tween.remove_all()
	tween.interpolate_property(path_follow, 'unit_offset', path_follow.get_unit_offset(), int(active), p / speed, 0, 2, delay)
	tween.start()
