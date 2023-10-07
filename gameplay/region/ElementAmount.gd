class_name ElementAmount

extends HBoxContainer

var amount : int = 0

func set_amount(new_amount) -> int:
	amount = new_amount
	$Amount.text = str(amount)
	return amount
