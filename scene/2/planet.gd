extends MarginContainer


#region var
@onready var regions = $Regions
@onready var areas = $Areas

var universe = null
var gods = []
var guesses = []
var sectors = {}
var extremes = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	universe = input_.universe
	
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_areas()
	init_regions()
	#solution_search()


func init_areas() -> void:
	var corners = {}
	corners.x = [0, Global.num.area.col - 1]
	corners.y = [0, Global.num.area.row - 1]
	
	areas.columns = Global.num.area.col
	
	for _i in Global.num.area.row:
		for _j in Global.num.area.col:
			var input = {}
			input.planet = self
			input.grid = Vector2(_j, _i)
			
			
			var area = Global.scene.area.instantiate()
			areas.add_child(area)
			area.set_attributes(input)


func init_regions() -> void:
	for extreme in Global.arr.area:
		extremes[extreme] = []
	
	for type in Global.arr.region:
		sectors[type] = []
		
		for _index in Global.num.area.n:
			var input = {}
			input.planet = self
			input.type = type
			input.index = int(_index)
	
			var region = Global.scene.region.instantiate()
			regions.add_child(region)
			region.set_attributes(input)


func get_area(grid_: Vector2) -> MarginContainer:
	var index = Global.num.area.n * grid_.y + grid_.x
	var area = areas.get_child(index)
	return area
#endregion


func add_god(god_: MarginContainer) -> void:
	gods.append(god_)
	god_.planet = self


func solution_search() -> void:
	while !guesses.is_empty():
		take_guess()


func take_guess() -> void:
	var area = guesses.pick_random()
	guesses.erase(area)
	
	var options = []
	
	for answer in area.question.answers.get_children():
		if answer.status == "probably":
			options.append(answer)
	
	if !options.is_empty():
		var option = options.pick_random()
		area.question.set_correct_answer(option.get_value())
		apply_answer_to_regions(area)


func apply_answer_to_regions(area_: MarginContainer) -> void:
	var value = area_.question.correct.get_value()
	
	for region in area_.regions:
		for area in region.areas:
			if area_ != area:
				area.question.set_incorrect_answer(value)


func detect_areas_for_golem(golem_: MarginContainer) -> Array:
	var restriction = golem_.get_restriction()
	var options = []
	
	match restriction.type:
		"area":
			for area in extremes[restriction.subtype]:
				if area.try_on_golem(golem_):
					options.append(area)
		"region":
			var region = sectors[restriction.subtype][restriction.index]
			
			for area in region.areas:
				if area.try_on_golem(golem_):
					options.append(area)
	
	#for option in options:
	#	option.recolor_based_on_type()
	return options

