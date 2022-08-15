extends CanvasLayer

onready var trans_screen : ColorRect
export var transition_color : = Color('#d5d5d5')

func _ready() -> void:
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 3
	trans_screen = ColorRect.new()
	trans_screen.color = transition_color
	trans_screen.rect_position = Vector2(0, 0)
	trans_screen.rect_min_size = Vector2(400, 320)
	add_child(canvas_layer)
	canvas_layer.add_child(trans_screen)
	
	var tween = get_tree().create_tween()
	tween.tween_property(trans_screen, 'rect_position', Vector2(0, -320), 0.5).set_ease(Tween.EASE_IN)

	$Fanfare.play()
	yield($Fanfare, 'finished')
	$Fanfare.queue_free()


func _on_Button_button_up() -> void:
	trans_screen.rect_position.y = 320
	var tween = get_tree().create_tween()
	tween.tween_property(trans_screen, 'rect_position', Vector2.ZERO, 0.5).set_ease(Tween.EASE_OUT)
	Globals.save_data()
	tween.tween_callback(get_tree(), 'change_scene', ['res://assets/scenes/TitleScreen.tscn'])
