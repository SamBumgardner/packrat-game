# Backpack to drag underneath gameplay columns.
extends Area2D

class_name Backpack

signal backpack_entered
signal backpack_exited

var selected : bool = false

var _frame_rate : int = 25
var _moving_to_target : bool = false
var _target_global_position : Vector2 = Vector2.ZERO
var _scale_down_original : float = 0.833333333333
var _scale_up_20_percent : float = 1.2

@export var _item_capacity : int = 2
var _contained_elements : Array[int] = []
var _contained_items : Array[Item] = []

@onready var collision_shape : Shape2D = $CollisionShape2D.shape
@onready var shadow : Sprite2D = $ShadowSprite

###########
# GENERAL #
###########
func _ready():
	shadow.visible = false
	_contained_elements.resize(GlobalConstants.Elements.size())
	_contained_elements.fill(0)

func _process(delta):
	_handle_movement(delta)

#####################
# MOVEMENT HANDLING #
#####################
func set_target_position(target : Vector2) -> void:
	_target_global_position = target
	_moving_to_target = true

func stop_movement() -> void:
	_moving_to_target = false
	_target_global_position = Vector2.ZERO

func _handle_movement(delta) -> void:
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

######################
# SELECTION HANDLING #
######################
func draw_front(in_front : bool) -> void:
	var previous_position = global_position
	top_level = in_front
	global_position = previous_position

func select_and_enlarge_backpack() -> void:
	selected = true
	shadow.visible = true
	$PackSprite.apply_scale(
		Vector2(_scale_up_20_percent, _scale_up_20_percent)
	)

func stop_deselect_shrink_backpack() -> void:
	stop_movement()
	selected = false
	shadow.visible = false
	$PackSprite.apply_scale(
		Vector2(_scale_down_original, _scale_down_original)
	)
	_mouse_overlap_manual_check()

func _mouse_overlap_manual_check() -> void:
	var manual_mouse_check_rect : Rect2 = Rect2(collision_shape.get_rect())
	manual_mouse_check_rect.position += global_position
	if manual_mouse_check_rect.has_point(get_viewport().get_mouse_position()):
		_on_mouse_entered()
	
func _on_mouse_entered() -> void:
	backpack_entered.emit(self)

func _on_mouse_exited() -> void:
	backpack_exited.emit(self)

#######################
# CONTENTS MANAGEMENT #
#######################
func add_item(item : Item) -> bool:
	var added_item : bool = false
	if _contained_items.size() < _item_capacity:
		_contained_elements.append(item)
		for i in _contained_elements.size():
			_contained_elements[i] += item.elements[i]
		added_item = true
	return added_item

func change_capacity(new_capacity : int) -> void:
	_item_capacity = new_capacity

func get_elements() -> Array[int]:
	return _contained_elements.duplicate()

func get_shadow() -> Sprite2D:
	return shadow

func remove_items() -> Array[Item]:
	for i in _contained_elements.size():
		_contained_elements[i] = 0
	var removed_items : Array[Item] = _contained_items.duplicate()
	_contained_items.clear()
	return removed_items
