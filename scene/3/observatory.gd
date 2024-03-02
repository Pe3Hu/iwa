extends MarginContainer


#region var
@onready var banners = $Banners

var god = null
var quadrants = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_banners()


func init_banners() -> void:
	for region in Global.arr.region:
		var indexs = []
		indexs.append_array(Global.arr.index)
		
		for _i in Global.num.banner.n:
			var input = {}
			input.region = {}
			input.region.subtype = region
			input.region.index = indexs.pick_random()
			indexs.erase(input.region.index)
			add_banner(input)


func add_banner(input_: Dictionary) -> void:
	input_.observatory = self
	input_.gem = {}
	input_.gem.magic = Global.arr.magic.pick_random()
	input_.gem.value = Global.dict.banner.magic[input_.gem.magic]
	
	var banner = Global.scene.banner.instantiate()
	banners.add_child(banner)
	banner.set_attributes(input_)


func add_golem(golem_: MarginContainer) -> void:
	var quadrant = golem_.area.quadrant
	
	if !quadrants.has(quadrant):
		quadrants[quadrant] = {}
		quadrants[quadrant].golems = []
		quadrants[quadrant].power = 0
	
	quadrants[quadrant].golems.append(golem_)
	quadrants[quadrant].power += golem_.mana.get_value()


func set_region_for_banners() -> void:
	for banner in banners.get_children():
		var sector = banner.restriction.subtype
		var index = banner.restriction.get_value()
		banner.region = god.planet.sectors[sector][index]
#endregion
