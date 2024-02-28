extends MarginContainer


#region vars
@onready var cave = $VBox/Cave

var pantheon = null
var planet = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pantheon = input_.pantheon
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.god = self
	cave.set_attributes(input)
#endregion


func start_conquest() -> void:
	for _i in 2:
		place_golem()


func place_golem() -> void:
	cave.add_golem()
	var golem = cave.golems.get_child(0)
	var areas = planet.detect_areas_for_golem(golem)
	
	if !areas.is_empty():
		cave.golems.remove_child(golem)
		var area = areas.pick_random()
		area.set_golem(golem)
	else:
		cave.golems.remove_child(golem)
		golem.queue_free()
