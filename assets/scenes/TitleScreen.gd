extends CanvasLayer

onready var animation = $AnimationPlayer


func _on_play_button_down() -> void:
	animation.play('MainToLevels')

func _on_level_sent(path : String) -> void:
	animation.play('ToLevel')
	yield(animation, 'animation_finished')
	get_tree().change_scene(path)


func _on_erase_button_up() -> void:
	Globals.erase_data()
	get_tree().reload_current_scene()


func _on_back_button_down() -> void:
	animation.play_backwards('MainToLevels')
