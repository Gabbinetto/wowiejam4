class_name Actor
extends KinematicBody2D

export var speed : = 150.0
export var jump_force : = 300.0
export var jump_cut : = 0.6
var velocity : = Vector2.ZERO
var speed_multiplier : = 1.0

func jump(_jump_force : float):
	velocity.y = -_jump_force


func jump_cut(_jump_cut : float):
	if Input.is_action_just_released('jump') and velocity.y < 0:
		velocity.y * _jump_cut

func gravity(g = Globals.gravity):
	if is_on_floor():
		velocity.y = g
	else:
		velocity.y += g
	velocity.y = clamp(velocity.y, -INF, Globals.max_fall_speed)
