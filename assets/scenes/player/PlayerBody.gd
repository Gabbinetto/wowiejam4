class_name PlayerBody
extends Actor

signal head_found

enum STATES {
	AI,
	COME_BACK
}
var state = STATES.AI

var player_head : Node2D
var set_dir : = 1.0

onready var dir : = Vector2(set_dir, 0)
onready var detector_area : = $Detector
onready var ai_indicator : = $AnimatedSprite/Indicator
onready var animated_sprite : = $AnimatedSprite

func _physics_process(delta: float) -> void:

	detector()
	
	# Horizontal movement
	if Input.is_action_just_pressed('change_ai'):
		state = STATES.AI if state == STATES.COME_BACK else STATES.COME_BACK
		if state == STATES.AI:
			dir.x = 1
	if state == STATES.COME_BACK:
		dir = (player_head.global_position - global_position).normalized()
	if is_on_wall():
		dir *= -1 # Bounce off wall
	velocity.x = dir.x * speed * speed_multiplier
	
	# Vertical movement
	gravity()
	if is_on_floor():
		if Input.is_action_just_pressed('jump') or (dir.y < -0.15 and state == STATES.COME_BACK):
			jump(jump_force)
	
	# A.I. indicator
	match state:
		STATES.AI:
			ai_indicator.color = Color.red
		STATES.COME_BACK:
			ai_indicator.color = Color.green
	
	# Animation
	if abs(velocity.x) < 0.1:
		animated_sprite.animation = 'Idle'
	else:
		animated_sprite.animation = 'Run'
	
	move_and_slide(velocity, Vector2.UP)

func detector():
	var bodies = detector_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group('Head') and Input.is_action_just_pressed('head'):
			emit_signal('head_found')
