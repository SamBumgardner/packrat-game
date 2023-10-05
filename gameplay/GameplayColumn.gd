# Column to reserve space for a region or a customer.
extends Control

class_name GameplayColumn

signal column_entered
signal column_exited

@export var column_index:int
@export var current_backpack:Backpack

@onready var anchor_point:Control = $AnchorPoint

func get_anchor_point_position():
	return anchor_point.global_position

func set_backpack(newBackpack:Backpack):
	current_backpack = newBackpack
	if current_backpack != null:
		var new_shadow = current_backpack.get_shadow()
		new_shadow.reparent(anchor_point)
		new_shadow.global_position = anchor_point.global_position
		current_backpack.reparent(anchor_point)
		current_backpack.set_target_position(anchor_point.global_position)
	# backpack has potentially changed, re-evaluate column stuff

func snap_backpack_to_anchor():
	if current_backpack != null:
		current_backpack.global_position = anchor_point.global_position
		current_backpack.stop_movement()

func _on_item_rect_changed():
	$CenterPoint/Area2D/CollisionShape2D.shape.set_size(size)

func _on_area_2d_mouse_entered():
	column_entered.emit(column_index)

func _on_area_2d_mouse_exited():
	column_exited.emit(column_index)
