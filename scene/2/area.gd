extends MarginContainer


#region var
@onready var bg = $BG
@onready var question = $Question

var planet = null
var grid = null
var type = null
var index = null
var regions = []
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
#endregion


func try_on_golem(golem_: MarginContainer) -> bool:
	if golem != null:
		return false
	
	var mana = golem_.mana.get_value()
	
	for answer in question.answers.get_children():
		if answer.get_value() == mana and answer.status != "incorrectly":
			return true
	
	return false


func set_golem(golem_: MarginContainer) -> void:
	golem = golem_
	add_child(golem)
	var mana = golem_.mana.get_value()
	question.set_correct_answer(mana)
	planet.apply_answer_to_regions(self)
