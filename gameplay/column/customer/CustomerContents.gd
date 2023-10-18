# Customers may buy from the backpack assigned to them.
# Currently, all customers buy everything at a rate of 1 Silver Coin per unique
#  element.
class_name CustomerContents

extends ColumnContents

@onready var trade_offer = $TradeOffer

@export var _customer : Customer = null

@onready var database = get_node("/root/Database")

const _customer_data_folder_path = "res://data/customers/"
const _default_customer_index = 0
var header_name : String = ""
const _possible_customer_file_name_list : Array[String] = [
	"customer001.tres",
	"customer002.tres",
	"customer003.tres"
]

var _current_customer_file_name = _possible_customer_file_name_list[
	_default_customer_index
]
var _current_customer_index = _default_customer_index

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_first_customer()
	set_header_properties(_customer.graphic, _customer.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _build_customer_file_path(file_name : String) -> String:
	return _customer_data_folder_path + file_name

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
	if (
		_customer.trade_formula == GlobalConstants.TradeFormula.COUNT_UNIQUE_ELEMENTS
	):
		# Default formula.
		var backpack_elements = column_backpack.get_elements()
		return _get_unique_element_count(column_backpack)

	if (
		_customer.trade_formula == GlobalConstants.TradeFormula.PAIR_OF_UNIQUE
	):
		var trade_formula_divisor = 2
		var trade_formula_reward_multiplier = 5

		var backpack_elements = column_backpack.get_elements()
		var trade_formula_matches = floor(
			_get_unique_element_count(column_backpack)
			/ trade_formula_divisor
		)
		return trade_formula_matches * trade_formula_reward_multiplier

	if (
		_customer.trade_formula == GlobalConstants.TradeFormula.THREE_OF_A_KIND
	):
		var trade_formula_filter_element_minimum = 3
		var trade_formula_reward_multiplier = 25

		var backpack_elements = column_backpack.get_elements()
		var element_type_matches = backpack_elements.filter(
			func(element : int): return (
				element >= trade_formula_filter_element_minimum
			)
		)
		var trade_formula_matches = element_type_matches.size()
		return trade_formula_matches * trade_formula_reward_multiplier


	# Default formula.
	var backpack_elements = column_backpack.get_elements()
	return _get_unique_element_count(column_backpack)

# Sets the active customer.
# Assumes a previous method call is keeping track of the random queue of
#  customers.
func _set_customer(new_customer : Customer) -> void:
	_customer = new_customer
	header_name = _customer.name
	set_header_properties(_customer.graphic, _customer.name)
	trade_offer.set_trade_formula(_customer.trade_formula)

func _set_customer_by_index(customer_index : int) -> void:
	if (
		customer_index < 0
		or customer_index >= _possible_customer_file_name_list.size()
	):
		push_warning(
			"Warning: Attempted to set invalid customer index of "
			+ str(customer_index)
			+ ". Request is ignored."
		)
		return

	_current_customer_index = customer_index
	_current_customer_file_name = _possible_customer_file_name_list[
		_current_customer_index
	]
	_set_customer(load(_build_customer_file_path(_current_customer_file_name)))

func _set_first_customer() -> void:
	_set_customer_by_index(_default_customer_index)

func _set_next_customer() -> void:
	var next_customer_index = (
		(_current_customer_index + 1)
		% _possible_customer_file_name_list.size()
	)
	_set_customer_by_index(next_customer_index)

func _set_purchase_backpack_contents(column_backpack : Backpack) -> void:
	var worth_silver_coin = _get_worth_silver_coin(column_backpack)

	column_backpack.remove_items()
	database.set_silver_coin_count(
		database.silver_coin_count
		+ worth_silver_coin
	)
	database.increment_trade_count()

func _set_random_customer() -> void:
	var randomized_customer_file_name = (
		_possible_customer_file_name_list.pick_random()
	)
	var randomized_customer_path = (
		_customer_data_folder_path
		+ randomized_customer_file_name
	)
	_set_customer(load(randomized_customer_path))

#####################
# NEXT DAY HANDLING #
#####################
func next_day(column_backpack : Backpack) -> void:
	if (_get_cannot_buy(column_backpack)):
		_set_next_customer()
		content_actions_complete.emit()
		return

	_set_purchase_backpack_contents(column_backpack)

	_set_next_customer()
	content_actions_complete.emit()
