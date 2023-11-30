class_name BackpackTweens


# Animate squish and slow rising action.
static func init_tween_bounce(tween_to_init : Tween, pack : Sprite2D) -> Tween:
	const squash_downward_grow_horizontal : float = 1.3
	const squash_downward_shift_vertical : float = 20
	const squash_downward_shrink_vertical : float = .9
	const step_duration_list : Array[float] = [
		.2,
		.4
	]

	# Step 1 of 2
	tween_to_init.tween_property(
		pack,
		"scale",
		Vector2(
			squash_downward_grow_horizontal,
			squash_downward_shrink_vertical
		),
		step_duration_list[0]
	).set_trans(Tween.TRANS_QUART)
	tween_to_init.parallel().tween_property(
		pack,
		"position",
		Vector2(
			0,
			squash_downward_shift_vertical
		),
		step_duration_list[0]
	).set_trans(Tween.TRANS_QUART)

	# Step 2 of 2
	tween_to_init.tween_property(
		pack,
		"scale",
		Vector2.ONE,
		step_duration_list[1]
	).set_trans(Tween.TRANS_LINEAR)
	tween_to_init.parallel().tween_property(
		pack,
		"position",
		Vector2.ZERO,
		step_duration_list[1]
	).set_trans(Tween.TRANS_LINEAR)

	tween_to_init.stop()
	tween_to_init.connect("finished", tween_to_init.stop)
	
	return tween_to_init

# Animate gentle wiggle.
static func init_tween_wiggle(tween_to_init : Tween, pack : Sprite2D) -> void:
	const step_duration_list : Array[float] = [
		.1,
		.1,
		.1
	]
	const wiggle_variant_clockwise : float = .05
	const wiggle_variant_counterclockwise : float = -wiggle_variant_clockwise

	# Step 1 of 3
	tween_to_init.tween_property(
		pack,
		"rotation",
		wiggle_variant_clockwise,
		step_duration_list[0]
	).set_trans(Tween.TRANS_CUBIC)

	# Step 2 of 3
	tween_to_init.tween_property(
		pack,
		"rotation",
		wiggle_variant_counterclockwise,
		step_duration_list[1]
	).set_trans(Tween.TRANS_CUBIC)

	# Step 3 of 3
	tween_to_init.tween_property(
		pack,
		"rotation",
		0,
		step_duration_list[2]
	).set_trans(Tween.TRANS_LINEAR)

	tween_to_init.stop()
	tween_to_init.connect("finished", tween_to_init.stop)

# Animate squeeze and shake.
static func init_tween_squeeze(tween_to_init : Tween, pack : Sprite2D, squeeze_callback : Callable) -> Tween:
	const squeeze_grow_vertical : float = 1.3
	const squeeze_upward_shift_vertical : float = -20
	const squeeze_shrink_horizontal : float = .5
	const wiggle_variant_clockwise : float = .05
	const wiggle_variant_counterclockwise : float = -wiggle_variant_clockwise
	const step_duration_list : Array[float] = [
		.2,
		.05,
		.05,
		.05,
		.1,
		.3,
		.5
	]

	# Step 1 of 2
	tween_to_init.tween_property(
		pack,
		"scale",
		Vector2(
			squeeze_shrink_horizontal,
			squeeze_grow_vertical
		),
		step_duration_list[0]
	).set_trans(Tween.TRANS_QUART)
	tween_to_init.parallel().tween_property(
		pack,
		"position",
		Vector2(
			0,
			squeeze_upward_shift_vertical
		),
		step_duration_list[0]
	).set_trans(Tween.TRANS_QUART)

	# Step 2 of 2
	# Step 1 of 3
	tween_to_init.tween_property(
		pack,
		"rotation",
		wiggle_variant_clockwise,
		step_duration_list[1]
	).set_trans(Tween.TRANS_CUBIC)

	# Step 2 of 3
	tween_to_init.tween_property(
		pack,
		"rotation",
		wiggle_variant_counterclockwise,
		step_duration_list[2]
	).set_trans(Tween.TRANS_CUBIC)

	# Step 3 of 3
	tween_to_init.tween_property(
		pack,
		"rotation",
		0,
		step_duration_list[3]
	).set_trans(Tween.TRANS_LINEAR)
	tween_to_init.tween_interval(step_duration_list[4])
	tween_to_init.tween_callback(squeeze_callback)
	tween_to_init.tween_interval(step_duration_list[5])

	# Step 3 of 3
	tween_to_init.tween_property(
		pack,
		"scale",
		Vector2.ONE,
		step_duration_list[6]
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween_to_init.parallel().tween_property(
		pack,
		"position",
		Vector2.ZERO,
		step_duration_list[6]
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	tween_to_init.stop()
	tween_to_init.connect("finished", tween_to_init.stop)
	
	return tween_to_init
