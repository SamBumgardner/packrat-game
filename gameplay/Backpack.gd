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

@export var backpack_graphic : Texture = preload("res://art/pack_1.png")
@export var _item_capacity : int = 2
var _contained_elements : Array[int] = []
var _contained_items : Array[Item] = []

@onready var collision_shape : Shape2D = $CollisionShape2D.shape
@onready var shadow : Sprite2D = $ShadowSprite
@onready var pack : Sprite2D = $PackSprite
@onready var _sfx_pickup : AudioStreamPlayer = $SFX_Pickup
@onready var _sfx_drop : AudioStreamPlayer = $SFX_BagDrop
@onready var _sfx_item_added : AudioStreamPlayer = $SFX_ItemAdded
@onready var _sfx_item_rejected : AudioStreamPlayer = $SFX_ItemRejected

var _tween_wiggle : Tween;
var _tween_bounce : Tween;


###########
# GENERAL #
###########
func _ready():
	shadow.visible = false
	_contained_elements.resize(GlobalConstants.Elements.size())
	_contained_elements.fill(0)
	_set_graphic(backpack_graphic)
	_init_tween_wiggle()
	_init_tween_bounce()

func _set_graphic(texture : Texture) -> void:
	pack.set_texture(texture)
	shadow.set_texture(texture)

func _process(delta):
	_handle_movement(delta)

##################
# TWEEN HANDLING #
##################
func _init_tween_wiggle() -> void:
	_tween_wiggle = create_tween()
	_tween_wiggle.tween_property(pack, "rotation", .05, .1).set_trans(Tween.TRANS_CUBIC)
	_tween_wiggle.tween_property(pack, "rotation", -.05, .1).set_trans(Tween.TRANS_CUBIC)
	_tween_wiggle.tween_property(pack, "rotation", 0, .1).set_trans(Tween.TRANS_LINEAR)
	_tween_wiggle.stop()
	_tween_wiggle.connect("finished", _tween_wiggle.stop)

func _init_tween_bounce() -> void:
	_tween_bounce = create_tween()
	_tween_bounce.tween_property(pack, "scale", Vector2(1.3, .9), .2).set_trans(Tween.TRANS_QUART)
	_tween_bounce.parallel().tween_property(pack, "position", Vector2(0, 20), .2).set_trans(Tween.TRANS_QUART)
	_tween_bounce.tween_property(pack, "scale", Vector2.ONE, .4).set_trans(Tween.TRANS_LINEAR)
	_tween_bounce.parallel().tween_property(pack, "position", Vector2(0, 0), .4).set_trans(Tween.TRANS_LINEAR)
	_tween_bounce.stop()
	_tween_bounce.connect("finished", _tween_bounce.stop)

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
	var previous_position : Vector2 = global_position
	top_level = in_front
	global_position = previous_position

func select_and_enlarge_backpack() -> void:
	selected = true
	shadow.visible = true
	$PackSprite.apply_scale(
		Vector2(_scale_up_20_percent, _scale_up_20_percent)
	)
	_sfx_pickup.play()

func stop_deselect_shrink_backpack() -> void:
	stop_movement()
	selected = false
	shadow.visible = false
	$PackSprite.apply_scale(
		Vector2(_scale_down_original, _scale_down_original)
	)
	_tween_wiggle.play()
	_sfx_drop.play()
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
		_contained_items.append(item)
		for i in _contained_elements.size():
			_contained_elements[i] += item.elements[i]
		added_item = true
		_tween_bounce.play()
		_sfx_item_added.play()
	else:
		_tween_wiggle.play()
		_sfx_item_rejected.play()
	return added_item

func get_max_capacity() -> int:
	return _item_capacity

func get_current_item_count() -> int:
	return _contained_items.size()

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
