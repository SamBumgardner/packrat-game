# Column to reserve space for a region or a customer.
extends Control

class_name GameplayColumn

@export var column_index:int
@export var current_backpack:Backpack

@onready var anchor_point:Control = $AnchorPoint

func get_anchor_point_position():
	return anchor_point.global_position

func set_backpack(newBackpack:Backpack):
	current_backpack = newBackpack
	if current_backpack != null:
		current_backpack.snap_position(anchor_point.global_position)
	# backpack has potentially changed, re-evaluate column stuff
