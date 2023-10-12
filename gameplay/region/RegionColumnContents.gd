class_name RegionColumnContents

extends VBoxContainer

@export var _item : Item = null

@onready var _preloaded_items : Array[Item] = [
		preload("res://gameplay/item/rock.tres"), 
		preload("res://gameplay/item/bone.tres")
		]
@onready var _element_display : SixElementDisplay = $SixElementDisplay

func _ready() -> void:
	set_item(load("res://gameplay/item/rock.tres"))

func next_day(column_backpack : Backpack) -> void:
	if column_backpack != null:
		column_backpack.add_item(_item)
	var randomized_item : Item = _preloaded_items.pick_random()
	set_item(randomized_item)

func set_item(new_item:Item) -> void:
	_item = new_item
	_element_display.update_elements(_item.elements)

