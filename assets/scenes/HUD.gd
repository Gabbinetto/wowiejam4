extends CanvasLayer

var level : int

func _ready() -> void:
	yield(get_parent(), 'ready')
	$LevelLabel.text = str(level)


func _on_restart_button_up() -> void:
	restart()


func _on_menu_button_up() -> void:
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 3
	
	var trans_screen = ColorRect.new()
	trans_screen.color = Color('#d5d5d5')
	trans_screen.rect_position = Vector2(0, 320)
	trans_screen.rect_min_size = Vector2(400, 320)
	add_child(canvas_layer)
	canvas_layer.add_child(trans_screen)
	
	var tween = get_tree().create_tween()
	tween.tween_property(trans_screen, 'rect_position', Vector2.ZERO, 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_callback(get_tree(), 'change_scene', ['res://assets/scenes/TitleScreen.tscn'])

func restart():
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 3
	
	var trans_screen = ColorRect.new()
	trans_screen.color = Color('#d5d5d5')
	trans_screen.rect_position = Vector2(0, 320)
	trans_screen.rect_min_size = Vector2(400, 320)
	add_child(canvas_layer)
	canvas_layer.add_child(trans_screen)
	
	var tween = get_tree().create_tween()
	tween.tween_property(trans_screen, 'rect_position', Vector2.ZERO, 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_callback(get_tree(), 'reload_current_scene')
