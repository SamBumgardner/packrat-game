# Abstract to inherit from.
#
# Used by RegionContents and CustomerContents.
# Descendents should emit `content_actions_complete` when `next_day` is called.
# Otherwise day will never end.
class_name ColumnContents

extends VBoxContainer

signal content_actions_complete

@onready var _header_graphic : Sprite2D = $Header/Control/Sprite2D
@onready var _header_label : RichTextLabel = $Header/Name

func set_header_properties(graphic : Texture, header_name : String) -> void:
	_header_graphic.set_texture(graphic)
	_header_label.text = header_name

# Function to overwrite as happening at the end of the last animation.
# Otherwise day will never end.
func next_day(_backpack : Backpack) -> void:
	pass
