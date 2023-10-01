# Backpack to drag underneath gameplay columns.
extends Area2D

signal released

var mouse_overlap = false
var selected = false

var _frame_rate = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	set_position(Vector2(20, 20))
	# Transform.Position.x = 20
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		global_position = lerp(
			global_position,
			get_global_mouse_position(),
			_frame_rate * delta
		)

#func set_snapped_position(vector2):
#	if not near_anchor:
#		set_position(vector2)
#		return
#
#	set_position(vector2)

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
