class_name Player
extends Actor


onready var detector_area : = $Detector
onready var animated_sprite : = $Sprite

export var body_speed_multiplier : = 1.0
const body_scene : = preload('res://assets/scenes/player/PlayerBody.tscn')
const head_scene : = preload('res://assets/scenes/player/Head.tscn')
const crate_scene : = preload('res://assets/scenes/items/Crate.tscn')
var detached : = false
var with_crate : = false
var facing_left : = false

var body : Node2D = null
var head : Node2D = null

func _ready() -> void:
	$HUD.level = get_parent().level
	

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
	
	# Flip crate
	$CrateSprite.position.x = -20 if facing_left else 7
	
	set_collision_layer_bit(1, !detached)
	
	velocity.x += conveyor_modifier
	if detached: # Move if possible
		velocity.x = 0
		global_position = body.global_position
	move_and_slide_with_snap(velocity, snap, Vector2.UP)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('head') and !detached:
		detach()
	if event.is_action_pressed('interact') and with_crate:
		$CrateSprite.visible = false
		var new_crate = crate_scene.instance()
		
		var can_drop = !test_move(transform, $CrateSprite.position)
		new_crate.global_position = $CrateSprite.global_position if can_drop else global_position
		get_parent().get_node('Items').add_child(new_crate)
		new_crate.set_owner(new_crate.get_parent())
		with_crate = false
	if event.is_action_pressed('reset'):
		$HUD.restart()


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
		body.global_position = global_position
		body.player_head = head
		body.speed *= body_speed_multiplier
		body.set_dir = Utils.facing_to_num(!facing_left)
		get_parent().add_child(body)
		body.connect('head_found', self, '_attach')
		$Sprite.visible = false
		detached = true
	

func _on_crate_picked_up(crate):
	if with_crate:
		return
	with_crate = true
	$CrateSprite.visible = true

	crate.queue_free()
