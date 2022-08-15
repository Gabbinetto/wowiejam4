extends Item

enum DIRECTIONS {RIGHT = 0, LEFT = -1}

const TILE_SIZE = 8

export(DIRECTIONS) var direction
export var boost : = 50.0
export(int, 2, 50) var length : = 2


onready var middle_piece = $MiddleTemplate
onready var left_piece = $SpritesContainer/Left
onready var right_piece = $SpritesContainer/Right
onready var sprites = $SpritesContainer
onready var area = $Area2D
onready var boost_multiplier : = 1 if direction == DIRECTIONS.RIGHT else -1

func _ready() -> void:
	
	for i in (length - 2):
		var new_middle = middle_piece.duplicate()
		new_middle.position.x = (i + 1) * TILE_SIZE
		new_middle.position.y = 0
		new_middle.visible = true
		sprites.add_child(new_middle)
	middle_piece.queue_free()
	middle_piece = null

	right_piece.position.x = (length - 1) * TILE_SIZE
	
	
#	var collision_size_and_position = Vector2((length / 2) * TILE_SIZE, 0.5 * TILE_SIZE)
#	$CollisionShape2D.shape.extents = collision_size_and_position
#	$CollisionShape2D.position = collision_size_and_position
	$CollisionPolygon2D.polygon = PoolVector2Array([
		Vector2(0, 0) * TILE_SIZE,
		Vector2(length, 0) * TILE_SIZE,
		Vector2(length, 1) * TILE_SIZE,
		Vector2(0, 1) * TILE_SIZE
	])

	
	var _speed_scale = 1 if direction == DIRECTIONS.RIGHT else -1
	
	if direction == DIRECTIONS.LEFT:
		var temp = left_piece.position
		left_piece.position = right_piece.position
		right_piece.position = temp
	
	var area_collision = $CollisionPolygon2D.duplicate()
	area_collision.position.y -= 2
	area.add_child(area_collision)
	
	set_active(active)

func set_active(val):
	active = val
	for sprite in sprites.get_children():
		sprite.flip_h = direction == DIRECTIONS.LEFT
		sprite.playing = active
		sprite.speed_scale = boost * 0.1
	play_trigger()

func _on_triggered(trigger):
	set_active(trigger)


func _on_Area2D_body_entered(body: Node) -> void:
	if !active:
		return
	
	if body.is_in_group('Player') or body.is_in_group('Body') or body.is_in_group('Crate'):
		body.conveyor_modifier = boost * boost_multiplier

func _on_Area2D_body_exited(body: Node) -> void:
	if !active:
		return
	if body.is_in_group('Player') or body.is_in_group('Body') or body.is_in_group('Crate'):
		body.conveyor_modifier = 0
