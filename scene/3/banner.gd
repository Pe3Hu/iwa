extends MarginContainer


#region var
@onready var restriction = $Traits/Tokens/Restriction
@onready var gem = $Traits/Tokens/Gem

var observatory = null
var region = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	observatory = input_.observatory
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	custom_minimum_size = Vector2(Global.vec.size.banner)
	init_traits(input_)


func init_traits(input_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.type = "restriction"
	input.subtype = input_.region.subtype
	input.value = input_.region.index
	restriction.set_attributes(input)
	
	input.type = "magic"
	input.subtype = input_.gem.magic
	input.value = input_.gem.value
	gem.set_attributes(input)
#endregion
