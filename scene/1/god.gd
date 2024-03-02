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
		#batch.combinations.total = []
		#batch.combinations.optimal = []
		#batch.optimal = null
		
		for region in batch.regions:
			region.find_all_combinations_for_batch(batch)
		
		#var n = batch.optimal#
		
		if batch.combinations.total.size() > 0:
			batch.sort_combinations_based_on_banners()
			batchs[batch] = batch.optimal
	
	if !batchs.keys().is_empty():
		print(batchs)
		cave.batch = Global.get_random_key(batchs)
		cave.batch.set_areas_for_golems()
		print(cave.batch.optimal)
	else:
		pass
