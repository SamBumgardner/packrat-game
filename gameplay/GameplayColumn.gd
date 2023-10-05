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
		current_backpack.reparent(anchor_point)
		current_backpack.position = Vector2.ZERO
	# backpack has potentially changed, re-evaluate column stuff

func _on_mouse_entered():
	print("entered at ", column_index)

func _on_item_rect_changed():
	$CenterPoint/Area2D/CollisionShape2D.shape.set_size(size)

func _on_area_2d_mouse_entered():
	print("shape entered at ", column_index)
	column_entered.emit(column_index)

func _on_area_2d_mouse_exited():
	print("shape exited at ", column_index)
	column_exited.emit(column_index)
