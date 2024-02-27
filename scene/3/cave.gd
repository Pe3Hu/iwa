extends MarginContainer


#region var
@onready var golems = $Golems

var god = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_golems()


func init_golems() -> void:
	for _i in 1:
		var input = {}
		input.cave = self
		input.diagrams = {}
		input.diagrams["rune"] = 2
		input.diagrams["spell"] = 2
		input.diagrams["massif"] = 2
		
		var golem = Global.scene.golem.instantiate()
		golems.add_child(golem)
		golem.set_attributes(input)
#endregion
