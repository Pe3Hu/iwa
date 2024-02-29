extends MarginContainer


#region vars
@onready var cave = $VBox/Cave
@onready var observatory = $VBox/Observatory

var pantheon = null
var planet = null
var index = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	pantheon = input_.pantheon
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.god = self
	cave.set_attributes(input)
	observatory.set_attributes(input)
	index = int(Global.num.index.god)
	Global.num.index.god += 1
#endregion


func find_region_for_batch() -> void:
	var batchs = {}
	
	for batch in cave.batchs.get_children():
		batch.combinations = []
		
		for region in batch.regions:
			region.find_all_combinations_for_batch(batch)
		
		var n = batch.combinations.size()
		
		if n > 0:
			batchs[batch] = n
	
	if !batchs.keys().is_empty():
		cave.batch = Global.get_random_key(batchs)
		cave.batch.set_areas_for_golems()
	else:
		pass


#func place_golem() -> void:
	#var batch = cave.batchs.get_child(0)
	#var golem = batch.golems[0]
	#var areas = planet.detect_areas_for_golem(golem)
	#
	#if !areas.is_empty():
		#batch.golems.erase(golem)
		#batch.remove_child(golem)
		#var area = areas.pick_random()
		#area.set_golem(golem)
	#else:
		#batch.golems.erase(golem)
		#batch.remove_child(golem)
		#golem.queue_free()
