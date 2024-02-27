extends MarginContainer


#region var
@onready var bg = $BG
@onready var question = $Question

var planet = null
var grid = null
var type = null
var index = null
var regions = []
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
	var h = float(Global.num.index.area) / pow(Global.num.area.n, 2)
	style.bg_color = Color.from_hsv(h, 0.9, 0.9)
	bg.set("theme_override_styles/panel", style)
	
	var input = {}
	input.area = self
	question.set_attributes(input)
	planet.guesses.append(self)
#endregion
