class_name RegionContents

extends ColumnContents

@export var _region : Region = null
@export var _item : Item = null

@onready var _element_display : SixElementDisplay = $Contents/SixElementDisplay
@onready var _item_name : RichTextLabel = $Contents/ItemName
@onready var _item_graphic : Sprite2D = $Contents/ItemGraphicControl/ItemGraphic
@onready var _fly_to_pack_graphic : Sprite2D = $Contents/ItemGraphicControl/FlyToPackItem

@onready var _tween_fly_to_pack : Tween = create_tween()
@onready var _tween_bonk_off_pack : Tween = create_tween()
var _tween_reveal_new_item : Tween

var header_graphic : Texture = null
var header_name : String = ""

func _ready() -> void:
	set_region(load("res://gameplay/column/region/region_forest.tres"))
	set_item(_region.possible_items.pick_random())
	update_item_display()
	set_header_properties(_region.graphic, _region.name)
	_init_tween_reveal_new_item()
	_tween_fly_to_pack.stop()
	_tween_bonk_off_pack.stop()

func _trigger_tween_fly_to_pack(target_pack : Backpack, item_accepted : bool):
	var randomized_offset = Vector2(20, 0).rotated(randf() * PI * 2)
	
	_tween_fly_to_pack = create_tween()
	_tween_fly_to_pack.set_ease(Tween.EASE_IN)
	_tween_fly_to_pack.tween_property(_fly_to_pack_graphic, "scale", Vector2(.5, .5), .1).set_trans(Tween.TRANS_QUAD)
	_tween_fly_to_pack.parallel().tween_property(_fly_to_pack_graphic, "position", _fly_to_pack_graphic.position + randomized_offset, .1).set_trans(Tween.TRANS_QUAD)
	_tween_fly_to_pack.tween_property(_fly_to_pack_graphic, "global_position", target_pack.global_position, 1).set_trans(Tween.TRANS_EXPO)
	_tween_fly_to_pack.parallel().tween_property(_fly_to_pack_graphic, "rotation", 12, 1).set_trans(Tween.TRANS_QUAD)
	_tween_fly_to_pack.parallel().tween_property(_fly_to_pack_graphic, "modulate", Color(1,1,1,0), 1).set_trans(Tween.TRANS_EXPO)
	
	if item_accepted:
		_tween_fly_to_pack.connect("finished", target_pack.react_item_added)
	else:
		_tween_fly_to_pack.connect("finished", target_pack.react_item_rejected)
		_tween_fly_to_pack.connect("finished", _trigger_tween_bonk_off_pack)
	_tween_fly_to_pack.connect("finished", _tween_reveal_new_item.play)
	_tween_fly_to_pack.play()

func _reset_flying_tween():
	_tween_fly_to_pack.stop()
	_tween_bonk_off_pack.stop()
	_reset_fly_to_pack_graphic()
	_fly_to_pack_graphic.set_texture(_item_graphic.texture)
	_fly_to_pack_graphic.show()

func _reset_fly_to_pack_graphic():
	_fly_to_pack_graphic.hide()
	_fly_to_pack_graphic.rotation = 0
	_fly_to_pack_graphic.scale = Vector2.ONE
	_fly_to_pack_graphic.modulate.a = 1.0
	_fly_to_pack_graphic.centered = true
	_fly_to_pack_graphic.position = _fly_to_pack_graphic.texture.get_size() / 2

func _trigger_tween_bonk_off_pack() -> void:
	var randomized_offset = Vector2(100, 0).rotated(-PI / 6 - randf() * .66 * PI)
	
	_tween_bonk_off_pack = create_tween()
	_tween_bonk_off_pack.set_ease(Tween.EASE_OUT)
	_tween_bonk_off_pack.tween_property(_fly_to_pack_graphic, "global_position", _fly_to_pack_graphic.global_position + randomized_offset, 1).set_trans(Tween.TRANS_CIRC)
	_tween_bonk_off_pack.parallel().tween_property(_fly_to_pack_graphic, "rotation", -6, 1).set_trans(Tween.TRANS_QUAD)
	_tween_bonk_off_pack.parallel().tween_property(_fly_to_pack_graphic, "modulate", Color(1,1,1,1), .5).set_trans(Tween.TRANS_EXPO)
	_tween_bonk_off_pack.set_ease(Tween.EASE_IN)
	_tween_bonk_off_pack.parallel().tween_property(_fly_to_pack_graphic, "scale", Vector2.ZERO, .5).set_trans(Tween.TRANS_QUAD)
	
	_tween_bonk_off_pack.play()

func _reset_item_graphic():
	_tween_reveal_new_item.stop()
	_tween_bonk_off_pack.stop()
	_reset_fly_to_pack_graphic()
	_fly_to_pack_graphic.set_texture(_item_graphic.texture)
	_fly_to_pack_graphic.show()

func _init_tween_reveal_new_item():
	_tween_reveal_new_item = create_tween()
	_tween_reveal_new_item.tween_property(_item_graphic, "modulate", Color(1,1,1,0), .2).set_trans(Tween.TRANS_EXPO)
	_tween_reveal_new_item.parallel().tween_property($Contents/ItemName, "modulate", Color(1,1,1,0), .2).set_trans(Tween.TRANS_EXPO)
	_tween_reveal_new_item.parallel().tween_property($Contents/SixElementDisplay, "modulate", Color(1,1,1,0), .2).set_trans(Tween.TRANS_EXPO)
	
	_tween_reveal_new_item.tween_property(_item_graphic, "modulate", Color(1,1,1,1), .5).set_trans(Tween.TRANS_EXPO)
	_tween_reveal_new_item.parallel().tween_property($Contents/ItemName, "modulate", Color(1,1,1,1), .5).set_trans(Tween.TRANS_EXPO)
	_tween_reveal_new_item.parallel().tween_property($Contents/SixElementDisplay, "modulate", Color(1,1,1,1), .5).set_trans(Tween.TRANS_EXPO)
	
	_tween_reveal_new_item.stop()
	_tween_reveal_new_item.connect("step_finished", func(step_i): if step_i == 0: update_item_display())
	_tween_reveal_new_item.connect("finished", emit_signal.bind("content_actions_complete"))
	_tween_reveal_new_item.connect("finished", _tween_reveal_new_item.stop)
	pass

func next_day(column_backpack : Backpack) -> void:
	if column_backpack != null:
		var item_accepted : bool = column_backpack.add_item(_item)
		fly_to_pack(column_backpack, item_accepted)
	var randomized_item : Item = _region.possible_items.pick_random()
	set_item(randomized_item)
	if column_backpack == null:
		_tween_reveal_new_item.play()

func set_region(new_region : Region) -> void:
	_region = new_region
	header_graphic = _region.graphic
	header_name = _region.name

func set_item(new_item : Item) -> void:
	_item = new_item

func update_item_display() -> void:
	_element_display.update_elements(_item.elements)
	_item_name.text = _item.name
	_item_graphic.set_texture(_item.graphic)

func fly_to_pack(column_backpack : Backpack, item_accepted : bool) -> void:
	_reset_flying_tween()
	_trigger_tween_fly_to_pack(column_backpack, item_accepted)
	$Contents/ItemGraphicControl/CPUParticles2D.restart()
	_item_graphic.modulate.a = 0
