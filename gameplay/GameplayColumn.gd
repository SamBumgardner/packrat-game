extends Control

var column_index = 1

func _ready():
	pass

func get_anchor_point():
	return $AnchorPoint.global_position
