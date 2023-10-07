class_name RegionColumnContents

extends VBoxContainer

@export var _item : Item = null

@onready var elements : Array[ElementAmount] = [$HBoxContainer/Nature,
		$HBoxContainer/Earth, $HBoxContainer2/Fire, $HBoxContainer2/Water,
		$HBoxContainer3/Air, $HBoxContainer3/Wild]
@onready var _sorted_elements : Array[ElementAmount] = elements.duplicate()

func _ready() -> void:
	init_element_amounts()
	set_item(load("res://gameplay/item/rock.tres"))

func init_element_amounts() -> void:
	for element in elements:
		if element.amount == 0:
			element.visible = false

func set_item(new_item:Item) -> void:
	_item = new_item
	for i in GlobalConstants.Elements.size():
		var new_amount = elements[i].set_amount(_item.elements[i])
		elements[i].visible = new_amount > 0

func element_amount_sort(a:ElementAmount, b:ElementAmount) -> bool:
	return a.amount < b.amount

func sort_element_display() -> void:
	_sorted_elements.sort_custom(element_amount_sort)
	for i in _sorted_elements.size():
		var new_parent_container : Node = $HBoxContainer
		if i >= 2 and i < 4:
			new_parent_container = $HBoxContainer2
		else:
			new_parent_container = $HBoxContainer3
		_sorted_elements[i].reparent(new_parent_container)
