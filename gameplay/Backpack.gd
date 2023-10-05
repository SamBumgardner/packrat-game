# Backpack to drag underneath gameplay columns.
extends Area2D

class_name Backpack

signal backpack_entered
signal backpack_exited

var selected = false

var _frame_rate = 25
var _moving_to_target = false
var _target_global_position:Vector2 = Vector2.ZERO
var _scale_down_original = 0.833333333333
var _scale_up_20_percent = 1.2

@export var _item_capacity = 2
var _contained_elements:Array[int] = []
var _contained_items:Array[Item] = []

@onready var collision_shape:Shape2D = $CollisionShape2D.shape
@onready var shadow:Sprite2D = $ShadowSprite

	###########
	# GENERAL #
	###########
func _ready():
	shadow.visible = false
	_contained_elements.resize(GlobalConstants.Elements.size())
	_contained_elements.fill(0)

func get_shadow():
	return shadow

	#####################
	# MOVEMENT HANDLING #
	#####################
func _process(delta):
	if selected:
		set_target_position(get_viewport().get_mouse_position())
	
	draw_front(_moving_to_target)
	if _moving_to_target:
		global_position = lerp(
			global_position,
			_target_global_position,
			_frame_rate * delta
		)
	
	if global_position.is_equal_approx(_target_global_position):
		stop_movement()

func set_target_position(target:Vector2):
	_target_global_position = target
	_moving_to_target = true

func stop_movement():
	_moving_to_target = false
	_target_global_position = Vector2.ZERO

	######################
	# SELECTION HANDLING #
	######################
func _mouse_overlap_manual_check():
	var manual_mouse_check_rect = Rect2(collision_shape.get_rect())
	manual_mouse_check_rect.position += global_position
	if manual_mouse_check_rect.has_point(get_viewport().get_mouse_position()):
		_on_mouse_entered()
	
func _on_mouse_entered():
	backpack_entered.emit(self)

func _on_mouse_exited():
	backpack_exited.emit(self)

func draw_front(in_front:bool):
	var previous_position = global_position
	top_level = in_front
	global_position = previous_position

func select_and_enlarge_backpack():
	selected = true
	shadow.visible = true
	$PackSprite.apply_scale(
		Vector2(_scale_up_20_percent, _scale_up_20_percent)
	)

func stop_deselect_shrink_backpack():
	stop_movement()
	selected = false
	shadow.visible = false
	$PackSprite.apply_scale(
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
