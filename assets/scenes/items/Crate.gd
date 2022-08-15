extends KinematicBody2D

signal picked_up(crate)

export var print_speed : = false

var velocity : = Vector2.ZERO
var conveyor_modifier : = 0.0

onready var detector : = $Detector

func _ready() -> void:
	yield(get_tree(), 'idle_frame')
	var player = get_tree().get_nodes_in_group('Player').front()
	if player:
		connect('picked_up', player, '_on_crate_picked_up')
	else:
		print('Player not found')

func _physics_process(delta: float) -> void:
	gravity()
	
	for body in detector.get_overlapping_bodies():
		if body.is_in_group('Player'):
			if Input.is_action_just_pressed('interact'):
				emit_signal('picked_up', self)
	
	velocity.x += conveyor_modifier
	if print_speed:
		print(velocity, ' ', conveyor_modifier)
	move_and_slide(velocity, Vector2.UP)

func gravity():
	if is_on_floor():
		velocity.y = Globals.gravity
	else:
		velocity.y += Globals.gravity
	velocity.y = clamp(velocity.y, -INF, Globals.max_fall_speed)
