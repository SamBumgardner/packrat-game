# Column to reserve space for a region or a customer.
extends Control

class_name GameplayColumn

signal column_entered
signal column_exited

@export var column_index : int
@export var current_backpack : Backpack
@export var column_type : GlobalConstants.ColumnContents

@onready var anchor_point : Control = $AnchorPoint
@onready var backpack_elements_display : SixElementDisplay = $Control/HBoxContainer/SixElementDisplayMini

const REGION_CONTENTS_SCENE = preload("res://gameplay/region/RegionColumnContents.tscn")
const COLUMN_CONTENTS_PRELOAD : Array[Resource] = [null, REGION_CONTENTS_SCENE]

var _column_contents : Node = null

func _ready() -> void:
	if column_type != GlobalConstants.ColumnContents.NONE:
		_column_contents = COLUMN_CONTENTS_PRELOAD[column_type].instantiate()
		$ColumnContents.add_child(_column_contents)

func get_anchor_point_position() -> Vector2:
	return anchor_point.global_position

# Need during init to make collision check match the columns after auto-resize
func _on_item_rect_changed() -> void:
	$CenterPoint/Area2D/CollisionShape2D.shape.set_size(size)

#####################
# NEXT DAY HANDLING #
#####################
func next_day() -> void:
	if column_type != GlobalConstants.ColumnContents.NONE:
		_column_contents.next_day(current_backpack)
	update_backpack_contents_display()

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
	update_backpack_contents_display()

func update_backpack_contents_display():
	if current_backpack != null:
		backpack_elements_display.update_elements(current_backpack.get_elements())
	else:
		backpack_elements_display.clear_elements()

func snap_backpack_to_anchor() -> void:
	if current_backpack != null:
		current_backpack.global_position = anchor_point.global_position
		current_backpack.stop_movement()

##################
# INPUT HANDLING #
##################
func _on_area_2d_mouse_entered() -> void:
	column_entered.emit(column_index)

func _on_area_2d_mouse_exited() -> void:
	column_exited.emit(column_index)
