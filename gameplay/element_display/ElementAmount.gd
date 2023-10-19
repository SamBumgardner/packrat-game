class_name ElementAmount

extends HBoxContainer

@export var color_tint : Color = Color.WHITE
@export var element_icon : Texture = preload("res://art/wild_icon.png")

var amount : int = 0

func _ready():
	$ElementIcon.modulate = color_tint
	$ElementIcon.texture = element_icon

func set_amount(new_amount) -> int:
	amount = new_amount
	$Amount.text = str(amount)
	return amount
