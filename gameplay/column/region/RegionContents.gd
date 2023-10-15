# Displays a region and handles its next day triggered logic.
class_name RegionContents

extends ColumnContents

@export var _region : Region = null
@export var _item : Item = null

@onready var _element_display : SixElementDisplay = $Contents/SixElementDisplay
@onready var _item_name : RichTextLabel = $Contents/ItemName
@onready var _item_graphic : Sprite2D = $Contents/ItemGraphicControl/ItemGraphic
@onready var _fly_to_pack_graphic : Sprite2D = $Contents/ItemGraphicControl/FlyToPackItem
@onready var _fly_item_sound : AudioStreamPlayer = $SFX_FlyItemSound

@onready var _tween_fly_to_pack : Tween = create_tween()
@onready var _tween_bonk_off_pack : Tween = create_tween()
var _tween_reveal_new_item : Tween

var header_graphic : Texture = null
var header_name : String = ""

##################
# INITIALIZATION #
##################
func _ready() -> void:
	set_region(load("res://gameplay/column/region/region_forest.tres"))
	set_item(_region.possible_items.pick_random())
	update_item_display()
	set_header_properties(_region.graphic, _region.name)
	_init_tween_reveal_new_item()
	_tween_fly_to_pack.stop()
	_tween_bonk_off_pack.stop()

func _init_tween_reveal_new_item():
	_tween_reveal_new_item = create_tween()
	RegionContentsTweens.init_tween_reveal_new_item(
		_tween_reveal_new_item,
		_item_graphic,
		_item_name,
		_element_display	
	)
	_tween_reveal_new_item.stop()

	_tween_reveal_new_item.connect("step_finished", func(step_i): if step_i == 0: update_item_display())
	_tween_reveal_new_item.connect("finished", emit_signal.bind("content_actions_complete"))
	_tween_reveal_new_item.connect("finished", _tween_reveal_new_item.stop)

#####################
# NEXT DAY HANDLING #
#####################
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

##################
# ITEM ANIMATION #
##################
func update_item_display() -> void:
	_element_display.update_elements(_item.elements)
	_item_name.text = _item.name
	_item_graphic.set_texture(_item.graphic)

func fly_to_pack(column_backpack : Backpack, item_accepted : bool) -> void:
	_tween_fly_to_pack.stop()
	_tween_bonk_off_pack.stop()
	RegionContentsTweens.reset_fly_to_pack_graphic(_fly_to_pack_graphic)
	
	_fly_to_pack_graphic.set_texture(_item_graphic.texture)
	_fly_to_pack_graphic.show()
	_item_graphic.modulate = Color.TRANSPARENT
	
	_fly_item_sound.play()
	_trigger_tween_fly_to_pack(column_backpack, item_accepted)

func _trigger_tween_fly_to_pack(target_pack : Backpack, item_accepted : bool):
	_tween_fly_to_pack = create_tween()
	_tween_fly_to_pack = RegionContentsTweens.init_tween_fly_to_pack(
		_tween_fly_to_pack, 
		_fly_to_pack_graphic, 
		target_pack
	)

	if item_accepted:
		_tween_fly_to_pack.connect("finished", target_pack.react_item_added)
	else:
		_tween_fly_to_pack.connect("finished", target_pack.react_item_rejected)
		_tween_fly_to_pack.connect("finished", _trigger_tween_bonk_off_pack)
	
	_tween_fly_to_pack.connect("finished", _tween_reveal_new_item.play)
	_tween_fly_to_pack.play()

func _trigger_tween_bonk_off_pack() -> void:
	_tween_bonk_off_pack = create_tween()
	RegionContentsTweens.init_tween_bonk_off_pack(
		_tween_bonk_off_pack, 
		_fly_to_pack_graphic
	)	
	_tween_bonk_off_pack.play()
