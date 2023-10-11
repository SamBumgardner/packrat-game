class_name ElementAmount

extends HBoxContainer

@export var color_tint : Color = Color.WHITE

var amount : int = 0

func _ready():
		$ElementIcon.modulate = color_tint

func set_amount(new_amount) -> int:
	amount = new_amount
	$Amount.text = str(amount)
	return amount
