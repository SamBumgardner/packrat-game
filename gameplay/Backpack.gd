# Backpack to drag underneath gameplay columns.
extends Area2D

signal released

var mouse_overlap = false
var selected = false

var _frame_rate = 25

func _process(delta):
	if selected:
		global_position = lerp(
			global_position,
			get_global_mouse_position(),
			_frame_rate * delta
		)

func snap_position_to_column(gameplay_column):
	var anchor_point = gameplay_column.get_anchor_point()
	set_position(anchor_point)

func _input(event):
	if not Input.is_action_just_pressed("click"):
		return

	if selected:
		released.emit()
		selected = false
		return

	if mouse_overlap:
		selected = true

func _on_mouse_entered():
	mouse_overlap = true

func _on_mouse_exited():
	mouse_overlap = false
