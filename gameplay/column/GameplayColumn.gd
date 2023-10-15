# Column to reserve space for a region or a customer.
extends Control

class_name GameplayColumn

signal column_entered
signal column_exited
signal ready_for_next_day

const CUSTOMER_CONTENTS_SCENE = preload(
	"res://gameplay/column/customer/CustomerContents.tscn"
)
const REGION_CONTENTS_SCENE = preload("res://gameplay/column/region/RegionContents.tscn")
const COLUMN_CONTENTS_PRELOAD : Array[Resource] = [
	null,
	REGION_CONTENTS_SCENE,
	CUSTOMER_CONTENTS_SCENE
]

@export var column_index : int
@export var current_backpack : Backpack
@export var column_type : GlobalConstants.ColumnContents

@onready var anchor_point : Control = $AnchorPoint
@onready var backpack_display : BackpackDisplay = $CenterBottom/BackpackDisplay
@onready var contents_root : Node = $Contents

var _column_contents : ColumnContents

func _ready() -> void:
	if column_type != GlobalConstants.ColumnContents.NONE:
		_column_contents = COLUMN_CONTENTS_PRELOAD[column_type].instantiate()
		_column_contents.content_actions_complete.connect(_on_content_actions_complete)
		contents_root.add_child(_column_contents)

func get_anchor_point_position() -> Vector2:
	return anchor_point.global_position

# Need during init to make collision check match the columns after auto-resize
func _on_item_rect_changed() -> void:
	$CenterPoint/Area2D/CollisionShape2D.shape.set_size(size)

#####################
# NEXT DAY HANDLING #
#####################
func next_day() -> void:
	if column_type == GlobalConstants.ColumnContents.NONE:
		ready_for_next_day.emit()
	else:
		_column_contents.next_day(current_backpack)

func _on_content_actions_complete() -> void:
	backpack_display.update_display(current_backpack)
	ready_for_next_day.emit()

####################
# BACKPACK CONTROL #
####################
func set_backpack(newBackpack : Backpack) -> void:
	current_backpack = newBackpack
	if current_backpack != null:
		var new_shadow : Sprite2D = current_backpack.get_shadow()
		new_shadow.reparent(anchor_point)
		new_shadow.global_position = anchor_point.global_position
		current_backpack.reparent(anchor_point)
		current_backpack.set_target_position(anchor_point.global_position)
		if !current_backpack.display_update.is_connected(_on_backpack_display_update):
			current_backpack.display_update.connect(_on_backpack_display_update)
	backpack_display.update_display(current_backpack)

func snap_backpack_to_anchor() -> void:
	if current_backpack != null:
		current_backpack.global_position = anchor_point.global_position
		current_backpack.stop_movement()

func _on_backpack_display_update(updatedBackpack : Backpack) -> void:
	if current_backpack == updatedBackpack:
		backpack_display.update_display(updatedBackpack)

##################
# INPUT HANDLING #
##################
func _on_area_2d_mouse_entered() -> void:
	column_entered.emit(column_index)

func _on_area_2d_mouse_exited() -> void:
	column_exited.emit(column_index)
