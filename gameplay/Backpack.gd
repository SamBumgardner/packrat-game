extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_position(Vector2(20, 20))
	# Transform.Position.x = 20
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func set_snapped_position(vector2):
#	if not near_anchor:
#		set_position(vector2)
#		return
#
#	set_position(vector2)

func snap_position_to_column(gameplay_column):
	var anchor_point = gameplay_column.get_anchor_point()
	set_position(anchor_point)
