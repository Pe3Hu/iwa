extends MarginContainer


#region var
@onready var bg = $BG

var planet = null
var type = null
var index = null
var areas = []
var manas = []
var gods = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	type = input_.type
	index = input_.index
	
	init_basic_setting()


func init_basic_setting() -> void:
	planet.sectors[type].append(self)
	init_areas()
	manas.append_array(Global.arr.mana)


func init_areas() -> void:
	match type:
		"quadrant":
			var n = Global.num.area.n / Global.num.region.n
			var x = index % Global.num.region.n
			var y = index / Global.num.region.n
			var grid = Vector2(x, y)
			
			for _i in n:
				for _j in n:
					var _grid = Vector2(_j, _i) + grid * n
					add_area(_grid)
		"row":
			for _i in Global.num.area.n:
				var _grid = Vector2(_i, index)
				add_area(_grid)
		"col":
			for _i in Global.num.area.n:
				var _grid = Vector2(index, _i)
				add_area(_grid)


func add_area(grid_: Vector2) -> void:
	var area = planet.get_area(grid_)
	areas.append(area)
	area.regions.append(self)
	
	if type == "quadrant":
		var n = float(Global.num.area.n / Global.num.region.n)
		var x = index % Global.num.region.n
		var y = index / Global.num.region.n
		var grid = grid_ - Vector2(x, y) * n
		var corners = {}
		corners.x = [0.0, n - 1]
		corners.y = [0.0, n - 1]
		var _type = null
		grid.x = float(grid.x)
		grid.y = float(grid.y)
		
		if corners.y.has(grid.y) or corners.x.has(grid.x):
			if corners.y.has(grid.y) and corners.x.has(grid.x):
				_type = "corner"
			else:
				_type = "edge"
		else:
			_type = "center"
		
		area.set_type(_type)
		area.quadrant = self
		area.recolor_based_on_quadrant()
#endregion


func check_batch_manas(batch_: MarginContainer) -> bool:
	for mana in batch_.manas:
		if !manas.has(mana):
			return false
	
	return true


func find_all_combinations_for_batch(batch_: MarginContainer) -> void:
	var pools = {}
	
	for golem in batch_.golems:
		pools[golem] = get_ares_for_golem(golem)
		
		if pools[golem].size() == 0:
			return
	
	var combinations = Global.get_unique_combinations(pools)
	batch_.combinations.total.append_array(combinations) 


func get_ares_for_golem(golem_: MarginContainer) -> Array:
	var result = []
	
	for area in areas:
		if area.try_on_golem(golem_):
			result.append(area)
	
	return result


func get_equilibrium() -> void:
	var datas = []
	
	for god in planet.gods:
		if god.observatory.quadrants.has(self):
			var data = {}
			data.god = god
			data.power = god.observatory.quadrants[self].power
			datas.append(data)
	
	datas.sort_custom(func(a, b): return a.power > b.power)
	var _index = planet.sectors.quadrant.find(self)
	var winner = datas.front().god
	
	print([_index, winner.index])
