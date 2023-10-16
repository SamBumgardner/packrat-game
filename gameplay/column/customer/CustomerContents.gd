# Customers may buy from the backpack assigned to them.
# Currently, all customers buy everything at a rate of 1 Silver Coin per unique
#  element.
class_name CustomerContents

extends ColumnContents

@export var _customer : Customer = null

@onready var database = get_node("/root/Database")

var header_name : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_mock_customer()
	set_header_properties(_customer.graphic, _customer.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_cannot_buy(column_backpack : Backpack):
	return not _get_wants_backpack(column_backpack)

func _get_has_backpack(column_backpack : Backpack):
	return column_backpack != null

func _get_has_at_least_one_element(column_backpack : Backpack):
	return _get_unique_element_count(column_backpack) > 0

func _get_unique_element_count(column_backpack : Backpack) -> int:
	var backpack_elements = column_backpack.get_elements()
	return (
		backpack_elements
			.filter(func(number): return number > 0)
			.size()
	)

# Returns true if the current customer will buy the backpack's contents.
func _get_wants_backpack(column_backpack : Backpack) -> bool:
	if _customer == null or not _get_has_backpack(column_backpack):
		return false

	return _get_has_at_least_one_element(column_backpack)

func _get_worth_silver_coin(column_backpack : Backpack) -> int:
	var backpack_elements = column_backpack.get_elements()
	return _get_unique_element_count(column_backpack)

func _set_purchase_backpack_contents(column_backpack : Backpack) -> void:
	var worth_silver_coin = _get_worth_silver_coin(column_backpack)

	column_backpack.remove_items()
	database.set_silver_coin_count(
		database.silver_coin_count
		+ worth_silver_coin
	)
	database.increment_trade_count()

#####################
# NEXT DAY HANDLING #
#####################
func next_day(column_backpack : Backpack) -> void:
	if (_get_cannot_buy(column_backpack)):
		content_actions_complete.emit()
		return

	_set_purchase_backpack_contents(column_backpack)

	content_actions_complete.emit()

func set_customer(new_customer : Customer) -> void:
	_customer = new_customer
	header_name = _customer.name

func _set_mock_customer() -> void:
	set_customer(load("res://gameplay/column/customer/customer001.tres"))
