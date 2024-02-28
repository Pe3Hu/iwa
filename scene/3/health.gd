extends "res://scene/3/token.gd"


var current = null
var maximum = null


func set_maximum() -> void:
	current = int(get_value())
	maximum = int(get_value())


func set_current(value_: int) -> void:
	current = 0
	set_value(current)


func change_current(value_: int) -> void:
	current += value_
	set_value(current)
	
	if current <= 0:
		set_current(0)
		breakage()


func breakage() -> void:
	pass
