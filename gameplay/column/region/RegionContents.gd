class_name RegionContents

extends ColumnContents

@export var _region : Region = null
@export var _item : Item = null

@onready var _element_display : SixElementDisplay = $Contents/SixElementDisplay
@onready var _item_name : RichTextLabel = $Contents/ItemName
@onready var _item_graphic : Sprite2D = $Contents/ItemGraphicControl/ItemGraphic

var header_graphic : Texture = null
var header_name : String = ""

func _ready() -> void:
	set_region(load("res://gameplay/column/region/region_forest.tres"))
	set_item(_region.possible_items.pick_random())
	set_header_properties(_region.graphic, _region.name)

func next_day(column_backpack : Backpack) -> void:
	if column_backpack != null:
		column_backpack.add_item(_item)
	var randomized_item : Item = _region.possible_items.pick_random()
	set_item(randomized_item)

func set_region(new_region : Region) -> void:
	_region = new_region
	header_graphic = _region.graphic
	header_name = _region.name

func set_item(new_item : Item) -> void:
	_item = new_item
	_element_display.update_elements(_item.elements)
	_item_name.text = new_item.name
	_item_graphic.set_texture(new_item.graphic)

