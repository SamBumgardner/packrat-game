# Backpack to drag underneath gameplay columns.
extends Area2D

class_name Backpack

signal backpack_entered
signal backpack_exited

var selected = false

var _frame_rate = 25
var _scale_down_original = 0.833333333333
var _scale_up_20_percent = 1.2

@export var _item_capacity = 2
var _contained_elements:Array[int] = []
var _contained_items:Array[Item] = []

@onready var collision_shape:Shape2D = $CollisionShape2D.shape

func _ready():
	_contained_elements.resize(GlobalConstants.Elements.size())
	_contained_elements.fill(0)

func _process(delta):
	if selected:
		global_position = lerp(
			global_position,
			get_global_mouse_position(),
			_frame_rate * delta
		)

	##################
	# INPUT HANDLING #
	##################
func _mouse_overlap_manual_check():
	var manual_mouse_check_rect = Rect2(collision_shape.get_rect())
	manual_mouse_check_rect.position += global_position
	if manual_mouse_check_rect.has_point(get_viewport().get_mouse_position()):
		_on_mouse_entered()
	
func _on_mouse_entered():
	backpack_entered.emit(self)

func _on_mouse_exited():
	backpack_exited.emit(self)

func select_and_enlarge_backpack():
	selected = true
	$Sprite2D.apply_scale(
		Vector2(_scale_up_20_percent, _scale_up_20_percent)
	)

func deselect_and_shrink_backpack():
	selected = false
	$Sprite2D.apply_scale(
		Vector2(_scale_down_original, _scale_down_original)
	)
	_mouse_overlap_manual_check()
	

	#######################
	# CONTENTS MANAGEMENT #
	#######################
func get_elements():
	return _contained_elements.duplicate()

func remove_items():
	for i in _contained_elements.size():
		_contained_elements[i] = 0
	var removed_items = _contained_items.duplicate()
	_contained_items.clear()
	return removed_items

func add_item(item:Item):
	var added_item = false
	if _contained_items.size() < _item_capacity:
		_contained_elements.append(item)
		for i in _contained_elements.size():
			_contained_elements[i] += item.elements[i]
		added_item = true
	return added_item

func change_capacity(new_capacity):
	_item_capacity = new_capacity



