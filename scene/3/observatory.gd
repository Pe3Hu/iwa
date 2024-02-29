extends MarginContainer


#region var
var god = null
var quadrants = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	pass


func add_golem(golem_: MarginContainer) -> void:
	var quadrant = golem_.area.quadrant
	
	if !quadrants.has(quadrant):
		quadrants[quadrant] = {}
		quadrants[quadrant].golems = []
		quadrants[quadrant].power = 0
	
	quadrants[quadrant].golems.append(golem_)
	quadrants[quadrant].power += golem_.mana.get_value()
#endregion
