extends MarginContainer


#region vars
@onready var bg = $BG
@onready var diagramEnchantments = $Enchantments/Diagram

var cave = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	cave = input_.cave
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	custom_minimum_size = Vector2(Global.vec.size.golem)
	
	init_bg_color()
	init_enchantments(input_)


func init_bg_color() -> void:
	var style = StyleBoxFlat.new()
	Global.rng.randomize()
	var h = Global.rng.randf_range(0.0, 1.0)
	var s = Global.rng.randf_range(0.5, 0.9)
	var v = Global.rng.randf_range(0.4, 0.9)
	style.bg_color = Color.from_hsv(h, s, v)
	bg.set("theme_override_styles/panel", style)


func init_enchantments(input_: Dictionary) -> void:
	for _diagram in input_.diagrams:
		var input = {}
		input.proprietor = self
		input.type = "diagram"
		input.subtype = _diagram
		input.power = input_.diagrams[_diagram]
		
		var diagram = Global.scene.token.instantiate()
		diagramEnchantments.add_child(diagram)
		diagram.set_attributes(input)
#endregion
