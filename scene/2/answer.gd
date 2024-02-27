extends "res://scene/3/token.gd"


var status = null


func _ready() -> void:
	set_status("probably")


func set_status(status_: String) -> void:
	status = status_
	
	match status:
		"probably":
			pass
		"correctly":
			pass
		"incorrectly":
			value.visible = false
