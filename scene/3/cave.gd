extends MarginContainer


#region var
@onready var batchs = $Batchs

var god = null
var batch = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Vector2(Global.vec.size.cave)


func init_batchs() -> void:
	for _i in 3:
		add_batch()


func reset_batchs() -> void:
	batch = null
	
	while batchs.get_child_count() > 0:
		var _batch = batchs.get_child(0)
		batchs.remove_child(_batch)
		_batch.queue_free()


func add_batch() -> void:
	var input = {}
	input.cave = self
	input.lap = god.planet.lap.get_number()
	
	var _batch = Global.scene.batch.instantiate()
	batchs.add_child(_batch)
	_batch.set_attributes(input)
#endregion


func place_batch_golems() -> void:
	if batch != null:
		batch.place_golems_on_region()
	
	#reset_batchs()
