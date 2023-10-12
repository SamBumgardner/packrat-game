class_name BackpackDisplay

extends HBoxContainer

@onready var _backpack_capacity : ProgressBar = $BackpackCapacity
@onready var _element_display : SixElementDisplay = $SixElementDisplayMini

func _ready() -> void:
	update_display(null)

func update_display(backpack : Backpack) -> void:
	if backpack != null:
		_element_display.update_elements(backpack.get_elements())
		update_capacity(backpack.get_max_capacity(), backpack.get_current_item_count())
	else:
		_element_display.clear_elements()
		hide_capacity()

func update_capacity(max_cap : int, current : int) -> void:
	_backpack_capacity.show()
	_backpack_capacity.max_value = max_cap
	_backpack_capacity.value = current

func hide_capacity() -> void:
	_backpack_capacity.hide()
