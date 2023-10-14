class_name RegionContentsTweens


static func init_tween_fly_to_pack(tween_to_init : Tween, fly_to_pack_graphic : Sprite2D, 
		target_pack : Backpack):
	var randomized_offset = Vector2(20, 0).rotated(randf() * PI * 2)
	
	tween_to_init.set_ease(Tween.EASE_IN)
	tween_to_init.tween_property(fly_to_pack_graphic, "scale", Vector2(.75, .75), .1).set_trans(Tween.TRANS_QUAD)
	tween_to_init.parallel().tween_property(fly_to_pack_graphic, "position", fly_to_pack_graphic.position + randomized_offset, .1).set_trans(Tween.TRANS_QUAD)
	tween_to_init.tween_property(fly_to_pack_graphic, "global_position", target_pack.global_position, 1).set_trans(Tween.TRANS_EXPO)
	tween_to_init.parallel().tween_property(fly_to_pack_graphic, "rotation", 12, 1).set_trans(Tween.TRANS_QUAD)
	tween_to_init.parallel().tween_property(fly_to_pack_graphic, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_EXPO)
	
	return tween_to_init
