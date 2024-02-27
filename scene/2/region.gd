extends MarginContainer


#region var
@onready var bg = $BG

var planet = null
var type = null
var index = null
var areas = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	type = input_.type
	index = input_.index
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_areas()
	planet.sectors[type].append(self)


func init_areas() -> void:
	match type:
		"quadrant":
			var n = Global.num.area.n / Global.num.region.n
			var x = index / Global.num.region.n
			var y = index % Global.num.region.n
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
#endregion
