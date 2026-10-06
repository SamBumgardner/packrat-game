# Backpack to drag underneath gameplay columns.
extends Area2D

class_name Backpack

signal display_update
signal backpack_entered
signal backpack_exited
signal finished_emitting_coins

##############
# PARAMETERS #
##############
# Parameters for movement.
var _moving_to_target : bool = false
var selected : bool = false
var _target_global_position : Vector2 = Vector2.ZERO

# Parameters for appearance and inventory.
const POSSIBLE_GRAPHICS : Array[Texture] = [
	preload("res://art/pack_1_c_scale.png"),
	preload("res://art/pack_2_c_scale.png"),
	preload("res://art/pack_3_c_scale.png")
]
static var used_graphic_indexes : Array[int] = []
@export var backpack_graphic : Texture
@export var _item_capacity : int = 2
@export var coin_destination : Vector2 = Vector2.ZERO
var _contained_elements : Array[int] = []
var _contained_items : Array[Item] = []

# Parameters for interactions, such as collision checks and visual details.
@onready var collision_shape : Shape2D = $CollisionShape2D.shape
@onready var shadow : Sprite2D = $ShadowSprite
@onready var _item_added_particles : CPUParticles2D = $ItemAddedParticles
@onready var coin_particles : DestinationParticles = $PackSprite/CoinParticles
@onready var pack : Sprite2D = $PackSprite

# Parameters for sound effects.
@onready var _sfx_drop : AudioStreamPlayer = $SFX_BagDrop
@onready var _sfx_item_added : AudioStreamPlayer = $SFX_ItemAdded
@onready var _sfx_item_rejected : AudioStreamPlayer = $SFX_ItemRejected
@onready var _sfx_pickup : AudioStreamPlayer = $SFX_Pickup
@onready var _sfx_coins : AudioStreamPlayer = $SFX_Coins

# Parameters for tween animations.
var _tween_wiggle : Tween
var _tween_bounce : Tween
var _tween_squeeze : Tween

# For tracking state of coin emission
var _is_emitting_coins : bool = false

###########
# GENERAL #
###########
func _ready():
	shadow.visible = false
	_contained_elements.resize(GlobalConstants.Elements.size())
	_contained_elements.fill(0)
	_set_random_pack_graphic()

	_tween_wiggle = create_tween()
	BackpackTweens.init_tween_wiggle(_tween_wiggle, pack)

	_tween_bounce = create_tween()
	BackpackTweens.init_tween_bounce(_tween_bounce, pack)
	
	_tween_squeeze = create_tween()
	BackpackTweens.init_tween_squeeze(_tween_squeeze, pack, emit_coins)
	
	coin_particles.particle_destination = coin_destination

func _set_random_pack_graphic() -> void:
	var selected_index = randi() % POSSIBLE_GRAPHICS.size()
	while selected_index in used_graphic_indexes \
			and used_graphic_indexes.size() < POSSIBLE_GRAPHICS.size():
		selected_index = (selected_index + 1) % POSSIBLE_GRAPHICS.size()
	backpack_graphic = POSSIBLE_GRAPHICS[selected_index]
	_set_graphic(backpack_graphic)
	used_graphic_indexes.append(selected_index)

func _set_graphic(texture : Texture) -> void:
	pack.set_texture(texture)
	shadow.set_texture(texture)

func _process(delta):
	_handle_movement(delta)
	_check_coin_emission()

func _check_coin_emission() -> void:
	if not _is_emitting_coins and coin_particles.emitting:
		_is_emitting_coins = true
	elif _is_emitting_coins and not coin_particles.emitting:
		_is_emitting_coins = false
		finished_emitting_coins.emit()

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
	const _frame_rate : int = 25

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
	const scale_up_20_percent : float = 1.2

	selected = true
	shadow.visible = true
	$PackSprite.apply_scale(Vector2(scale_up_20_percent, scale_up_20_percent))
	_sfx_pickup.play()

func stop_deselect_shrink_backpack() -> void:
	const scale_down_original : float = 0.833333333333

	stop_movement()
	selected = false
	shadow.visible = false
	$PackSprite.apply_scale(Vector2(scale_down_original, scale_down_original))
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
	return added_item

func get_max_capacity() -> int:
	return _item_capacity

func get_current_item_count() -> int:
	return _contained_items.size()

func change_capacity(new_capacity : int) -> void:
	_item_capacity = new_capacity
	display_update.emit(self)

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

#####################
# DISPLAY REACTIONS #
#####################
func react_item_added():
	_tween_bounce.play()
	_sfx_item_added.play()
	_item_added_particles.restart()
	display_update.emit(self)

func react_item_rejected():
	_tween_wiggle.play()
	_sfx_item_rejected.play()

func react_sale_completed():
	$SFX_Squeeze.play()
	_tween_squeeze.play()

func emit_coins():
	coin_particles.restart()
	_sfx_coins.play()
