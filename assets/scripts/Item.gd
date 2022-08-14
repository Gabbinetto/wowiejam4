class_name Item
extends KinematicBody2D

signal triggered(trigger)

export var gravity_affected : = false
export var active : = true

var velocity = Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if gravity_affected:
		gravity()

func gravity(g = Globals.gravity):
	if is_on_floor():
		velocity.y = g
	else:
		velocity.y += g
	velocity.y = clamp(velocity.y, -INF, Globals.max_fall_speed)

func _on_trigger(trigger : bool):
	active = trigger
