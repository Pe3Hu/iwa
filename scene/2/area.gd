extends MarginContainer


#region var
@onready var bg = $BG
@onready var question = $Question

var planet = null
var grid = null
var type = null
var index = null
var regions = []
var quadrant = null
var golem = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	grid = input_.grid
	
	init_basic_setting()


func init_basic_setting() -> void:
	index = int(Global.num.index.area)
	Global.num.index.area += 1
	custom_minimum_size = Global.vec.size.area
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	recolor_based_on_index()
	
	var input = {}
	input.area = self
	question.set_attributes(input)
	planet.guesses.append(self)


#func set_quadrant() -> void:
	#for region in regions:
		#if region.type == "quadrant":
			#quadrant = region
			#break


func set_type(type_) -> void:
	type = type_
	planet.extremes[type].append(self)


func recolor_based_on_index() -> void:
	var style = bg.get("theme_override_styles/panel")
	var h = float(Global.num.index.area) / pow(Global.num.area.n, 2)
	style.bg_color = Color.from_hsv(h, 0.9, 0.9)


func recolor_based_on_type() -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.area[type]


func recolor_based_on_quadrant() -> void:
	var style = bg.get("theme_override_styles/panel")
	var h = planet.sectors.quadrant.find(quadrant) / Global.num.area.n
	style.bg_color = Color.from_hsv(h, 0.9, 0.9)
#endregion


func try_on_golem(golem_: MarginContainer) -> bool:
	if golem != null:
		return false
	
	if !check_golem_mana(golem_):
		return false
	
	if !check_golem_restrictions(golem_):
		return false
	
	return true


func check_golem_mana(golem_: MarginContainer) -> bool:
	var mana = golem_.mana.get_value()
	
	for answer in question.answers.get_children():
		if answer.get_value() == mana and answer.status != "incorrectly":
			return true
	
	return false


func check_golem_restrictions(golem_: MarginContainer) -> bool:
	var restriction = golem_.get_restriction()
	
	match restriction.type:
		"area":
			if !planet.extremes[restriction.subtype].has(self):
				return false
		"region":
			var region = planet.sectors[restriction.subtype][restriction.index]
			
			if !region.areas.has(self):
				return false
	
	return true


func set_golem(golem_: MarginContainer) -> void:
	golem = golem_
	add_child(golem)
	var mana = golem_.mana.get_value()
	question.set_correct_answer(mana)
	planet.apply_answer_to_regions(self)
	golem.recolor_based_on_god()
	
