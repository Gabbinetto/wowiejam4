extends Item

export var jump_force = 500.0


func _process(delta: float) -> void:
	$AnimatedSprite.playing = active
	if !active:
		$AnimatedSprite.frame = 0

func _on_body_entered(body: Node) -> void:
	print(active)
	if !active:
		return
	if body.is_in_group('Player') or body.is_in_group('Body'):
		body.jump(jump_force)

