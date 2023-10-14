class_name RegionContentsTweens

###############
# FLY TO PACK #
###############
static func init_tween_fly_to_pack(tween_to_init : Tween, fly_to_pack_graphic : Sprite2D, 
		target_pack : Backpack) -> Tween:
	var randomized_offset = Vector2(20, 0).rotated(randf() * PI * 2)
	
	tween_to_init.set_ease(Tween.EASE_IN)
	tween_to_init.tween_property(fly_to_pack_graphic, "scale", Vector2(.75, .75), .1).set_trans(Tween.TRANS_QUAD)
	tween_to_init.parallel().tween_property(fly_to_pack_graphic, "position", fly_to_pack_graphic.position + randomized_offset, .1).set_trans(Tween.TRANS_QUAD)
	tween_to_init.tween_property(fly_to_pack_graphic, "global_position", target_pack.global_position, 1).set_trans(Tween.TRANS_EXPO)
	tween_to_init.parallel().tween_property(fly_to_pack_graphic, "rotation", 12, 1).set_trans(Tween.TRANS_QUAD)
	tween_to_init.parallel().tween_property(fly_to_pack_graphic, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_EXPO)
	
	return tween_to_init

static func reset_fly_to_pack_graphic(graphic_to_reset : Sprite2D) -> Sprite2D:
	graphic_to_reset.hide()
	graphic_to_reset.rotation = 0
	graphic_to_reset.scale = Vector2.ONE
	graphic_to_reset.modulate.a = 1.0
	graphic_to_reset.centered = true
	graphic_to_reset.position = graphic_to_reset.texture.get_size() / 2
	
	return graphic_to_reset

#################
# BONK OFF PACK #
#################
static func init_tween_bonk_off_pack(tween_to_init : Tween, fly_to_pack_graphic : Sprite2D) -> Tween:
	var randomized_offset = Vector2(100, 0).rotated(-PI / 6 - randf() * .66 * PI)
	
	tween_to_init.set_ease(Tween.EASE_OUT)
	tween_to_init.tween_property(fly_to_pack_graphic, "global_position", fly_to_pack_graphic.global_position + randomized_offset, 1).set_trans(Tween.TRANS_CIRC)
	tween_to_init.parallel().tween_property(fly_to_pack_graphic, "rotation", -6, 1).set_trans(Tween.TRANS_QUAD)
	tween_to_init.parallel().tween_property(fly_to_pack_graphic, "modulate", Color(1,1,1,1), .5).set_trans(Tween.TRANS_EXPO)
	tween_to_init.set_ease(Tween.EASE_IN)
	tween_to_init.parallel().tween_property(fly_to_pack_graphic, "scale", Vector2.ZERO, .5).set_trans(Tween.TRANS_QUAD)

	return tween_to_init

###################
# REVEAL NEW ITEM #
###################
static func init_tween_reveal_new_item(tween_to_init : Tween, item_graphic : Sprite2D, 
		item_name : RichTextLabel, element_display : SixElementDisplay) -> Tween:

	tween_to_init.tween_property(item_graphic, "modulate", Color(1,1,1,0), .2).set_trans(Tween.TRANS_EXPO)
	tween_to_init.parallel().tween_property(item_name, "modulate", Color(1,1,1,0), .2).set_trans(Tween.TRANS_EXPO)
	tween_to_init.parallel().tween_property(element_display, "modulate", Color(1,1,1,0), .2).set_trans(Tween.TRANS_EXPO)
	
	tween_to_init.tween_property(item_graphic, "modulate", Color(1,1,1,1), .5).set_trans(Tween.TRANS_EXPO)
	tween_to_init.parallel().tween_property(item_name, "modulate", Color(1,1,1,1), .5).set_trans(Tween.TRANS_EXPO)
	tween_to_init.parallel().tween_property(element_display, "modulate", Color(1,1,1,1), .5).set_trans(Tween.TRANS_EXPO)
	
	return tween_to_init
