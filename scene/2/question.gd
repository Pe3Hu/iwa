extends MarginContainer


#region var
@onready var answers = $Answers

var area = null
var correct = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	area = input_.area
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_answers()


func init_answers() -> void:
	answers.columns = sqrt(Global.num.answer.n)
	
	for _i in Global.num.answer.n:
		var input = {}
		input.proprietor = self
		input.type = "answer"
		input.value = _i + 1
		input.subtype = str(input.value)
		
		var answer = Global.scene.answer.instantiate()
		answers.add_child(answer)
		answer.set_attributes(input)


func set_correct_answer(value_: int) -> void:
	for answer in answers.get_children():
		if answer.get_value() == value_:
			answer.set_status("correctly")
			correct = answer
		else:
			answer.set_status("incorrectly")


func set_incorrect_answer(value_: int) -> void:
	for answer in answers.get_children():
		if answer.get_value() == value_:
			answer.set_status("incorrectly")
			return
#endregion
