extends KinematicBody2D

export var speed : = 300.0
export var jump_force : = 300.0
export var jump_cut : = 0.6
export var weight : = 1

var can_move = true

var velocity : = Vector2.ZERO



func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	
	# Horizontal movement
	var horizontal : = Input.get_action_strength('move_right') - Input.get_action_strength('move_left')
	velocity.x = horizontal * speed
	
	# Vertical movement
	if is_on_floor():
		velocity.y = Globals.gravity
		if Input.is_action_just_pressed('jump'):
			jump()
	else:
		velocity.y += Globals.gravity
	
	if Input.is_action_just_released('jump') and velocity.y < 0:
		velocity.y *= jump_cut
	
	
	if can_move: # Move if possible
		move_and_slide(velocity, Vector2.UP)

func jump():
	if is_on_floor():
		velocity.y = -jump_force
