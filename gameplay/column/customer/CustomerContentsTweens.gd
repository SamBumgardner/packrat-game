class_name CustomerContentsTweens

const ANY_ANGLE_RADIANS : float = PI * 2

#############################
# FLY FROM PACK TO CUSTOMER #
#############################
static func init_tween_fly_from_pack_to_customer(
	tween_to_init : Tween,
	fly_from_pack_to_customer_graphic : Sprite2D, 
	target_pack : Backpack
) -> Tween:
	const step_durations : Array[float] = [.1, 1]

	const step_0_scale = Vector2(.75, .75)
	const step_0_position_offset_unrotated : Vector2 = Vector2(20, 0)
	var step_0_randomized_offset = step_0_position_offset_unrotated.rotated(
		randf() * ANY_ANGLE_RADIANS
	)
	var step_0_position = (
		fly_from_pack_to_customer_graphic.position
		+ step_0_randomized_offset
	)

	var step_1_global_position : Vector2 = target_pack.global_position
	const step_1_rotation_clockwise : float = 12
	const step_1_modulate : Color = Color.TRANSPARENT

	# Step 1 of 2
	tween_to_init.set_ease(Tween.EASE_IN)
	tween_to_init.tween_property(
		fly_from_pack_to_customer_graphic, "scale",  
		step_0_scale, 
		step_durations[0]
	).set_trans(Tween.TRANS_QUAD)
	tween_to_init.parallel().tween_property(
		fly_from_pack_to_customer_graphic, "position", 
		step_0_position, 
		step_durations[0]
	).set_trans(Tween.TRANS_QUAD)

	# Step 2 of 2
	tween_to_init.tween_property(
		fly_from_pack_to_customer_graphic, "global_position", 
		step_1_global_position, 
		step_durations[1]
	).set_trans(Tween.TRANS_EXPO)
	tween_to_init.parallel().tween_property(
		fly_from_pack_to_customer_graphic, "rotation", 
		step_1_rotation_clockwise, 
		step_durations[1]
	).set_trans(Tween.TRANS_QUAD)
	tween_to_init.parallel().tween_property(
		fly_from_pack_to_customer_graphic, "modulate", 
		step_1_modulate, 
		step_durations[1]
	).set_trans(Tween.TRANS_EXPO)

	return tween_to_init
