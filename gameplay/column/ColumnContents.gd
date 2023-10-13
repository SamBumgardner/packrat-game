class_name ColumnContents

extends VBoxContainer

@onready var _header_graphic : Sprite2D = $Header/Control/Sprite2D
@onready var _header_label : RichTextLabel = $Header/Name

func set_header_properties(graphic : Texture, name : String) -> void:
	_header_graphic.set_texture(graphic)
	_header_label.text = name

func next_day(backpack : Backpack) -> void:
	pass
