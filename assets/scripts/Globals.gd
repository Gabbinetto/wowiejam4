extends Node

const save_data_path = 'user://data.sav'

export var gravity : = 20
export var max_fall_speed : = 400

const levels = {
	0: true,
	1: false,
	2: false,
	3: false,
	4: false,
	5: false,
	6: false,
	7: false,
	8: false,
	9: false,
	10: false,
	11: false,
	12: false,
	13: false,
	14: false,
}
var completed_levels : = {}

func _ready() -> void:
	completed_levels = load_data()
	
func _notification(what: int) -> void:
	if what in [MainLoop.NOTIFICATION_WM_QUIT_REQUEST, MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST]:
		save_data()


func save_data():
	var file = File.new()
	file.open(save_data_path, File.WRITE)
	file.store_var(completed_levels)
	
func load_data():
	var file = File.new()
	file.open(save_data_path, File.READ)
	var data = file.get_var()
	print(data)
	if !data:
		return levels.duplicate()
	return data

func erase_data():
	var dir = Directory.new()
	dir.remove(save_data_path)
	load_data()
