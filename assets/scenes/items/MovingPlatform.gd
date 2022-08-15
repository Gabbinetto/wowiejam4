extends Item

export var one_way : = false
export var once : = false
export var delay : = 0.0
export var speed : = 50
onready var destination_points : = get_children()

var path : = PoolVector2Array([])
var next_pos : = 1
var last_state : = 0
var back : = false

func _ready() -> void:
	var nums = range(destination_points.size())
	nums.invert()
	for i in nums:
		if !(destination_points[i] is Position2D):
			destination_points.remove(i)
	
	path.append(global_position)
	for pos in destination_points:
		path.append(pos.global_position)
	
	if active:
		start_tween(1)


func _process(delta: float) -> void:
	$Polygon2D.color = Color.green if active else Color.red


func _physics_process(delta: float) -> void:	
	if active:
		check_step()


func check_step():
	if global_position == path[next_pos]:
		next_pos += 1 if !back else -1
		if next_pos >= path.size() and !one_way:
			next_pos = 0
		if one_way and (next_pos >= path.size() or next_pos < 0):
			back = !back
			next_pos -= 2 if back else -2
		if once:
			active = false
		if active:
			start_tween()


func start_tween(delay : = 0.0):
	var tween : = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	var p : float = (path[next_pos] - global_position).length()
	tween.tween_property(self, 'global_position', path[next_pos], p / speed).set_delay(delay)


func set_active(val):
	active = val
	if val == true:
		play_trigger()
		start_tween()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group('Player') or body.is_in_group('Body'):
		if body.is_in_group('Body'):
			print(body.state)
			last_state = body.state
			body.state = body.STATES.OFF


func _on_body_exited(body: Node) -> void:
	if body.is_in_group('Player') or body.is_in_group('Body'):
		if body.is_in_group('Body'):
			body.state = last_state


func _on_triggered(trigger : bool):
	set_active(trigger)
