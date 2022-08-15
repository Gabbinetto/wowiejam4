class_name Item
extends KinematicBody2D

signal triggered(trigger)

export var active : = true
const TriggerSound : = preload('res://assets/sounds/trigger_sound.tscn')

var trigger_sound : AudioStreamPlayer
var velocity = Vector2.ZERO

func _ready() -> void:
	trigger_sound = TriggerSound.instance()
	add_child(trigger_sound)
	trigger_sound.owner = self

func gravity(g = Globals.gravity):
	if is_on_floor():
		velocity.y = g
	else:
		velocity.y += g
	velocity.y = clamp(velocity.y, -INF, Globals.max_fall_speed)

func _on_triggered(trigger : bool):
	active = trigger


func play_trigger():
	if active:
		trigger_sound.pitch_scale = rand_range(-0.85, 1.15)
		trigger_sound.play()
