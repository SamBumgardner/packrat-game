# Backpack to drag underneath gameplay columns.
extends Area2D

class_name Backpack

signal backpack_selected
signal backpack_released

var mouse_overlap = false
var selected = false

var _frame_rate = 25
var _scale_down_original = 0.833333333333
var _scale_up_20_percent = 1.2

func _process(delta):
	if selected:
		global_position = lerp(
			global_position,
			get_global_mouse_position(),
			_frame_rate * delta
		)

func snap_position(new_position:Vector2):
	set_position(new_position)
	# emit events, play sounds, wiggle backpack here.

func _deselect_and_shrink_backpack():
	backpack_released.emit()
	selected = false
	$Sprite2D.apply_scale(
		Vector2(_scale_down_original, _scale_down_original)
	)

func _input(event):
	if not Input.is_action_just_pressed("click"):
		return

	if selected:
		_deselect_and_shrink_backpack()
		return

	if mouse_overlap:
		_select_and_enlarge_backpack()

func _on_mouse_entered():
	mouse_overlap = true

func _on_mouse_exited():
	mouse_overlap = false

func _select_and_enlarge_backpack():
	selected = true
	$Sprite2D.apply_scale(
		Vector2(_scale_up_20_percent, _scale_up_20_percent)
	)
	backpack_selected.emit(self)
