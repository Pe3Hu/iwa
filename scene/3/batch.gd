extends MarginContainer


#region vars
@onready var first = $First
@onready var second = $Second
@onready var third = $Third

var cave = null
var lap = null
var golems = []
var manas = []
var regions = []
var combinations = []
var region = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	cave = input_.cave
	lap = input_.lap
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Vector2(Global.vec.size.batch)
	init_golems()
	init_regions()


func init_golems() -> void:
	roll_manas()
	
	for _i in manas.size():
		var input = {}
		input.order = Global.arr.order[_i]
		input.mana = manas[_i]
		add_golem(input)


func roll_manas() -> void:
	var _lap = int(lap)
	
	if !Global.dict.batch.lap.keys().has(_lap):
		_lap = Global.dict.batch.lap.keys().back()
	
	var options = Global.dict.batch.lap[_lap]
	manas = Global.get_random_key(options)


func add_golem(input_: Dictionary) -> void:
	var ranks = [1, 2]
	input_.batch = self
	input_.rank = ranks.pick_random()
	input_.health = 10
	roll_restriction(input_)
	roll_gems(input_)
	roll_titulus(input_)
	
	var golem = get(input_.order)#Global.scene.golem.instantiate()
	golem.set_attributes(input_)
	golems.append(golem)


func roll_restriction(input_: Dictionary) -> void:
	var options = Global.dict.restriction.rank[input_.rank]
	input_.restriction = options.pick_random()
	input_.restriction.index = null
	
	if input_.restriction.type == "region":
		Global.rng.randomize()
		input_.restriction.index = Global.rng.randi_range(0, Global.num.area.n - 1)
	
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


func init_regions() -> void:
	for _region in cave.god.planet.regions.get_children():
		if _region.check_batch_manas(self):
			regions.append(_region)
#endregion


func set_areas_for_golems() -> void:
	if !combinations.is_empty():
		var combination = combinations.pick_random()
		
		for _i in golems.size():
			var golem = golems[_i]
			var area = combination[_i]
			golem.area = area


func place_golems_on_region() -> void:
	while !golems.is_empty():
		var golem = golems.pop_front()
		remove_child(golem)
		golem.area.set_golem(golem)
		cave.god.observatory.add_golem(golem)
