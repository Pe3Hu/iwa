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
	#init_golems()
	pass


func init_golems() -> void:
	for _i in 1:
		add_golem()


func add_golem() -> void:
	var input = {}
	input.cave = self
	input.mana = Global.arr.mana.pick_random()
	input.rank = 2
	input.health = 10
	roll_restriction(input)
	roll_gems(input)
	roll_titulus(input)
	
	var golem = Global.scene.golem.instantiate()
	golems.add_child(golem)
	golem.set_attributes(input)


func roll_restriction(input_: Dictionary) -> void:
	var options = Global.dict.restriction.rank[input_.rank]
	input_.restriction = options.pick_random()
	input_.restriction.index = null
	
	if input_.restriction.type == "region":
		Global.rng.randomize()
		input_.restriction.index = Global.rng.randi_range(0, Global.num.area.n)
	
	#input_.restriction.type = "region"
	#input_.restriction.subtype = "quadrant"
	#input_.restriction.index = 1


func roll_gems(input_: Dictionary) -> void:
	var kinds = Global.dict.kind[input_.mana]
	var options = []
	options.append_array(Global.arr.magic)
	
	input_.gems = {}
	
	for kind in kinds:
		var option = options.pick_random()
		input_.gems[option] = kind
		options.erase(option)


func roll_titulus(input_: Dictionary) -> void:
	var magic = input_.gems.keys().front()
	var kind = input_.gems[magic]
	var options = Global.dict.titulus.magic[magic][kind]
	input_.titulus = options.pick_random()
#endregion
