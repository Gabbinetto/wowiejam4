class_name Player
extends Actor

onready var detector_area = $Detector
onready var animated_sprite = $Sprite

const body_scene = preload('res://assets/scenes/player/PlayerBody.tscn')
const head_scene = preload('res://assets/scenes/player/Head.tscn')
var detached = false
var facing_left = false

var body : Node = null
var head : Node = null

func _physics_process(delta: float) -> void:
	
	# Horizontal movement
	var horizontal : = Input.get_action_strength('move_right') - Input.get_action_strength('move_left')
	velocity.x = horizontal * speed * speed_multiplier
	
	# Vertical movement
	gravity()
	
	# Animation
	if velocity.x == 0:
		animated_sprite.animation = 'Idle'
	else:
		animated_sprite.animation = 'Run'
	
	if velocity.x < 0:
		facing_left = true
	elif velocity.x > 0:
		facing_left = false
	animated_sprite.flip_h = facing_left
	
	if detached: # Move if possible
		velocity.x = 0
	move_and_slide(velocity, Vector2.UP)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('head') and !detached:
		detach()

func _attach():
	if detached:
		facing_left = head.get_node('Sprite').flip_h
		
		var tween_time : = 0.5
		var tween : = get_tree().create_tween()
		tween.tween_property(body, 'global_position', global_position, tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(head, 'global_position', global_position + Vector2(0, -4), tween_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_callback(body, 'queue_free')
		tween.parallel().tween_callback(head, 'queue_free')
		yield(tween, 'finished')
		
		body = null
		head = null
		$Sprite.visible = true
		detached = false

func detach():
	if !detached:
		head = head_scene.instance()
		head.global_position = global_position + Vector2(0, -4)
		head.get_node('Sprite').flip_h = animated_sprite.flip_h
		get_parent().add_child(head)
		
		body = body_scene.instance()
		body.global_position = global_position + Vector2(0, 0)
		body.player_head = head
		body.set_dir = Utils.facing_to_num(!facing_left)
		get_parent().add_child(body)
		body.connect('head_found', self, '_attach')
		$Sprite.visible = false
		detached = true
	

