class_name RegionContentsTweens

const ANY_ANGLE_RADIANS : float = PI * 2


###############
# FLY TO PACK #
###############
static func init_tween_fly_to_pack(tween_to_init : Tween, fly_to_pack_graphic : Sprite2D, 
		target_pack : Backpack) -> Tween:
	const step_durations : Array[float] = [.1, 1]
	
	const step_0_scale = Vector2(.75, .75)
	const step_0_position_offset_unrotated : Vector2 = Vector2(20, 0)
	var   step_0_randomized_offset = step_0_position_offset_unrotated.rotated(randf() * ANY_ANGLE_RADIANS)
	var   step_0_position = fly_to_pack_graphic.position + step_0_randomized_offset
	
	var   step_1_global_position : Vector2 = target_pack.global_position
	const step_1_rotation_clockwise : float = 12
	const step_1_modulate : Color = Color.TRANSPARENT
	
	tween_to_init.set_ease(Tween.EASE_IN)
	tween_to_init.tween_property(
		fly_to_pack_graphic, "scale",  
		step_0_scale, 
		step_durations[0]
	).set_trans(Tween.TRANS_QUAD)
	tween_to_init.parallel().tween_property(
		fly_to_pack_graphic, "position", 
		step_0_position, 
		step_durations[0]
	).set_trans(Tween.TRANS_QUAD)
	
	tween_to_init.tween_property(
		fly_to_pack_graphic, "global_position", 
		step_1_global_position, 
		step_durations[1]
	).set_trans(Tween.TRANS_EXPO)
	tween_to_init.parallel().tween_property(
		fly_to_pack_graphic, "rotation", 
		step_1_rotation_clockwise, 
		step_durations[1]
	).set_trans(Tween.TRANS_QUAD)
	tween_to_init.parallel().tween_property(
		fly_to_pack_graphic, "modulate", 
		step_1_modulate, 
		step_durations[1]
	).set_trans(Tween.TRANS_EXPO)
	
	return tween_to_init

static func reset_fly_to_pack_graphic(graphic_to_reset : Sprite2D) -> Sprite2D:
	graphic_to_reset.hide()
	graphic_to_reset.rotation = 0
	graphic_to_reset.scale = Vector2.ONE
	graphic_to_reset.modulate = Color.WHITE
	graphic_to_reset.centered = true
	graphic_to_reset.position = graphic_to_reset.texture.get_size() / 2
	
	return graphic_to_reset

#################
# BONK OFF PACK #
#################
static func init_tween_bonk_off_pack(tween_to_init : Tween, fly_to_pack_graphic : Sprite2D) -> Tween:
	const step_durations = [1.0]

	var   randomized_upward_angle = -PI / 6 - randf() * .66 * PI
	const position_offset_unrotated : Vector2 = Vector2(100, 0)
	
	var   step_0_randomized_offset : Vector2 = position_offset_unrotated.rotated(randomized_upward_angle)
	var   step_0_global_position : Vector2 = fly_to_pack_graphic.global_position + step_0_randomized_offset
	const step_0_rotation : float = -6
	const step_0_disappear_duration = step_durations[0] / 2.0
	const step_0_modulate : Color = Color.WHITE
	const step_0_scale : Vector2 = Vector2.ZERO

	tween_to_init.set_ease(Tween.EASE_OUT)
	tween_to_init.tween_property(
		fly_to_pack_graphic, "global_position", 
		step_0_global_position, 
		step_durations[0]
	).set_trans(Tween.TRANS_CIRC)
	tween_to_init.parallel().tween_property(
		fly_to_pack_graphic, "rotation", 
		step_0_rotation, 
		step_durations[0]
	).set_trans(Tween.TRANS_QUAD)
	tween_to_init.parallel().tween_property(
		fly_to_pack_graphic, "modulate",
		step_0_modulate, 
		step_0_disappear_duration
	).set_trans(Tween.TRANS_EXPO)
	tween_to_init.set_ease(Tween.EASE_IN)
	tween_to_init.parallel().tween_property(
		fly_to_pack_graphic, "scale", 
		step_0_scale, 
		step_0_disappear_duration
	).set_trans(Tween.TRANS_QUAD)

	return tween_to_init

###################
# REVEAL NEW ITEM #
###################
static func init_tween_reveal_new_item(tween_to_init : Tween, item_graphic : Sprite2D, 
		item_name : RichTextLabel, element_display : SixElementDisplay) -> Tween:
	const step_durations = [.2, .5]
	
	const step_0_modulate = Color.TRANSPARENT
	
	const step_1_modulate = Color.WHITE

	tween_to_init.tween_property(
		item_graphic, "modulate", 
		step_0_modulate, 
		step_durations[0]
	).set_trans(Tween.TRANS_EXPO)
	tween_to_init.parallel().tween_property(
		item_name, "modulate", 
		step_0_modulate, 
		step_durations[0]
	).set_trans(Tween.TRANS_EXPO)
	tween_to_init.parallel().tween_property(
		element_display, "modulate", 
		step_0_modulate, 
		step_durations[0]
	).set_trans(Tween.TRANS_EXPO)
	
	tween_to_init.tween_property(
		item_graphic, "modulate", 
		step_1_modulate, 
		step_durations[1]
	).set_trans(Tween.TRANS_EXPO)
	tween_to_init.parallel().tween_property(
		item_name, "modulate", 
		step_1_modulate, 
		step_durations[1]
	).set_trans(Tween.TRANS_EXPO)
	tween_to_init.parallel().tween_property(
		element_display, "modulate", 
		step_1_modulate, 
		step_durations[1]
	).set_trans(Tween.TRANS_EXPO)
	
	return tween_to_init
