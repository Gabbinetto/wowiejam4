extends CanvasLayer

onready var animation = $AnimationPlayer
const Transition = preload('res://assets/scenes/Transition.tscn')

func _on_play_button_down() -> void:
	animation.play('MainToLevels')
	$Menus/MainMenu/PlayButtonPivot/PlayButton.disabled = true

func _on_level_sent(path : String) -> void:
	animation.play('ToLevel')
	yield(animation, 'animation_finished')
	get_tree().change_scene(path)
