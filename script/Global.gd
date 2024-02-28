extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.mana = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	arr.magic = ["rune", "seal", "spell", "ritual", "massif"]
	arr.region = ["quadrant", "row", "col"]
	arr.kind = ["small", "medium", "large"]
	arr.area = ["center", "edge", "corner"]


func init_num() -> void:
	num.index = {}
	num.index.area = 0
	
	num.answer = {}
	num.answer.n = 9
	
	num.region = {}
	num.region.n = 3
	
	num.area = {}
	num.area.n = pow(num.region.n, 2)
	num.area.col = num.area.n
	num.area.row = num.area.n
	
	num.answer = {}
	num.answer.n = 9


func init_dict() -> void:
	init_neighbor()
	init_kind()
	init_gem()
	init_restriction()
	init_titulus()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_kind() -> void:
	dict.kind = {}
	var steps = {}
	steps[0] = [0, 2, 5]
	steps[1] = [1, 4, 7]
	steps[2] = [3, 6, 8]
	var indexs = [0, 0, 0]
	
	for _i in arr.mana.size():
		var power = _i + 1
		
		for step in steps:
			if steps[step].has(_i):
				indexs[step] += 1
		
		dict.kind[power] = []
		
		for _j in indexs.size():
			if indexs[_j] > 0:
				var index = indexs[_j] - 1
				var kind = arr.kind[index]
				dict.kind[power].append(kind)


func init_gem() -> void:
	dict.gem = {}
	dict.gem.magic = {}
	var exceptions = ["magic"]
	
	var path = "res://asset/json/iwa_gem.json"
	var array = load_data(path)
	
	for gem in array:
		var data = {}
		
		for key in gem:
			if !exceptions.has(key):
				data[key] = gem[key]
			
		if !dict.gem.magic.has(gem.magic):
			dict.gem.magic[gem.magic] = {}
	
		dict.gem.magic[gem.magic] = data


func init_restriction() -> void:
	dict.restriction = {}
	dict.restriction.rank = {}
	var exceptions = ["rank"]
	
	var path = "res://asset/json/iwa_restriction.json"
	var array = load_data(path)
	
	for restriction in array:
		restriction.rank = int(restriction.rank)
		var data = {}
		
		for key in restriction:
			if !exceptions.has(key):
				data[key] = restriction[key]
			
		if !dict.restriction.rank.has(restriction.rank):
			dict.restriction.rank[restriction.rank] = []
	
		dict.restriction.rank[restriction.rank].append(data)


func init_titulus() -> void:
	dict.titulus = {}
	dict.titulus.index = {}
	dict.titulus.magic = {}
	var exceptions = ["index", "magic"]
	
	var path = "res://asset/json/iwa_titulus.json"
	var array = load_data(path)
	
	for titulus in array:
		var data = {}
		
		for key in titulus:
			var words = key.split(" ")
			
			if exceptions.has(words[0]):
				data[key] = titulus[key]
			
			if words[0] == "magic":
				match words[1]:
					"title":
						if !dict.titulus.magic.has(titulus[key]):
							dict.titulus.magic[titulus[key]] = {}
					"kind":
						if !dict.titulus.magic[titulus["magic title"]].has(titulus[key]):
							dict.titulus.magic[titulus["magic title"]][titulus[key]] = []
		
		dict.titulus.index[titulus.index] = data
		dict.titulus.magic[titulus["magic title"]][titulus["magic kind"]].append(titulus.index)


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.planet = load("res://scene/2/planet.tscn")
	scene.area = load("res://scene/2/area.tscn")
	scene.region = load("res://scene/2/region.tscn")
	scene.answer = load("res://scene/2/answer.tscn")
	
	scene.golem = load("res://scene/3/golem.tscn")
	scene.token = load("res://scene/3/token.tscn")
	scene.gem = load("res://scene/3/gem.tscn")


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	vec.size.number = Vector2(vec.size.sixteen)
	vec.size.token = Vector2(24, 24)
	vec.size.area = Vector2(vec.size.token) * 3
	vec.size.golem = Vector2(vec.size.area)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.magic = {}
	color.magic.rune = Color.from_hsv(0 / h, 0.0, 0.7)
	color.magic.seal = Color.from_hsv(0 / h, 0.6, 0.7)
	color.magic.spell = Color.from_hsv(120 / h, 0.6, 0.7)
	color.magic.ritual = Color.from_hsv(60 / h, 0.6, 0.7)
	color.magic.massif = Color.from_hsv(210 / h, 0.6, 0.7)
	
	color.area = {}
	color.area.center = Color.from_hsv(0 / h, 0.0, 0.2)
	color.area.corner = Color.from_hsv(120 / h, 0.0, 0.8)
	color.area.edge = Color.from_hsv(210 / h, 0.0, 0.5)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
