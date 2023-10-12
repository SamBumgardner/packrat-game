class_name SixElementDisplay

extends VBoxContainer

@onready var elements : Array[ElementAmount] = [$HBoxContainer/Nature,
		$HBoxContainer/Earth, $HBoxContainer2/Fire, $HBoxContainer2/Water,
		$HBoxContainer3/Air, $HBoxContainer3/Wild]
@onready var _sorted_elements : Array[ElementAmount] = elements.duplicate()

const EMPTY_ELEMENTS : Array[int] = [0,0,0,0,0,0]

func _ready() -> void:
	init_element_amounts()

func init_element_amounts() -> void:
	for element in elements:
		if element.amount == 0:
			element.visible = false

func update_elements(new_element_values : Array[int]) -> void:
	for i in GlobalConstants.Elements.size():
		var new_amount = elements[i].set_amount(new_element_values[i])
		elements[i].visible = new_amount > 0
	_sort_element_display()

func clear_elements() -> void:
	update_elements(EMPTY_ELEMENTS)

func _element_amount_sort(a:ElementAmount, b:ElementAmount) -> bool:
	return a.amount > b.amount

func _sort_element_display() -> void:
	_sorted_elements.sort_custom(_element_amount_sort)
	for i in _sorted_elements.size():
		var new_parent_container : Node
		match i:
			0, 1:
				new_parent_container = $HBoxContainer
			2, 3:
				new_parent_container = $HBoxContainer2
			4, 5:
				new_parent_container = $HBoxContainer3
		_sorted_elements[i].reparent(new_parent_container)
		_sorted_elements[i].move_to_front()
