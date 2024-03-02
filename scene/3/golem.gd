extends MarginContainer


#region vars
@onready var bg = $BG
@onready var gems = $Gems/Tokens
@onready var restriction = $Traits/Tokens/Restriction
@onready var titulus = $Traits/Tokens/Titulus
@onready var mana = $Mana
@onready var health = $Health

var batch = null
var magic = null
var area = null
var banners = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	batch = input_.batch
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	custom_minimum_size = Vector2(Global.vec.size.golem)
	magic = input_.gems.keys().front()
	
	init_enchantments(input_)
	init_traits(input_)
	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	recolor_based_on_magic()


func init_enchantments(input_: Dictionary) -> void:
	for _magic in input_.gems:
		var input = {}
		input.proprietor = self
		input.type = "magic"
		input.subtype = _magic
		var kind = input_.gems[magic]
		input.value = Global.dict.gem.magic[_magic][kind]
		
		var gem = Global.scene.token.instantiate()
		gems.add_child(gem)
		gem.set_attributes(input)


func init_traits(input_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.type = "restriction"
	input.subtype = str(input_.restriction.subtype)
	
	if input_.restriction.index != null:
		input.value = input_.restriction.index
	else:
		input.value = -1
		restriction.value.visible = false
	
	restriction.set_attributes(input)
	
	input.type = "titulus"
	input.subtype = str(input_.titulus)
	titulus.set_attributes(input)
	titulus.value.visible = false
	
	input.type = "golem"
	input.subtype = "mana"
	input.value = input_.mana
	mana.set_attributes(input)
	
	input.type = "golem"
	input.subtype = "health"
	input.value = input_.health
	health.set_attributes(input)
	health.set_maximum()


func recolor_based_on_magic() -> void:
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.magic[magic]
	Global.rng.randomize()
	var h = style.bg_color.h#Global.rng.randf_range(0.0, 1.0)
	var s = style.bg_color.s#Global.rng.randf_range(0.5, 0.9)
	var v = style.bg_color.v#Global.rng.randf_range(0.4, 0.9)
	
	if magic != "rune":
		var step = 0.1
		h += Global.rng.randf_range(-step, step)
	else:
		var step = 0.3
		v += Global.rng.randf_range(-step, step)
	
	if h < 0:
		h += 1
	
	style.bg_color = Color.from_hsv(h, s, v)
	bg.set("theme_override_styles/panel", style)


func recolor_based_on_god() -> void:
	var style = bg.get("theme_override_styles/panel")
	var index = batch.cave.god.planet.gods.find(batch.cave.god)
	style.bg_color = Global.color.god[index]
#endregion


func get_restriction() -> Dictionary:
	var result = {}
	result.subtype = restriction.designation.subtype
	result.index = restriction.value.subtype
	
	if Global.arr.region.has(result.subtype):
		result.type = "region"
	
	if Global.arr.area.has(result.subtype):
		result.type = "area"
	return result


func set_area(area_: MarginContainer) -> void:
	area = area_
	
	for banner in batch.cave.god.observatory.banners.get_children():
		if banner.region.areas.has(area):
			apply_banner(banner)


func apply_banner(banner_: MarginContainer) -> void:
	for gem in gems.get_children():
		if banner_.gem.subtype == gem.subtype:
			var value = banner_.gem.get_value()
			gem.change_value(value)
