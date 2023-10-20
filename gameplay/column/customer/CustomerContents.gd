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
	"customer003.tres",
	"customer004.tres",
	"customer005.tres",
	"customer006.tres",
	"customer007.tres",
	"customer008.tres",
	"customer009.tres",
	"customer010.tres",
	"customer011.tres",
	"customer012.tres",
	"customer013.tres",
	"customer014.tres",
	"customer015.tres",
	"customer016.tres",
	"customer017.tres",
	"customer018.tres",
	"customer019.tres",
	"customer020.tres",
	"customer021.tres",
	"customer022.tres",
	"customer023.tres"
]

var _current_customer_file_name = _possible_customer_file_name_list[
	_default_customer_index
]
var _current_customer_index = _default_customer_index

static var _previously_selected_customers : Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_random_customer()
	set_header_properties(_customer.graphic, _customer.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _build_customer_file_path(file_name : String) -> String:
	return _customer_data_folder_path + file_name

func _get_cannot_buy(column_backpack : Backpack):
	return not TradeEvaluateSelectors.get_wants_backpack(
		column_backpack,
		_customer
	)

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

func _set_random_customer() -> void:
	if _previously_selected_customers.size() >= _possible_customer_file_name_list.size():
		_previously_selected_customers.clear()
	
	var random_index = randi() % _possible_customer_file_name_list.size()
	while random_index in _previously_selected_customers:
		random_index = (random_index + 1) % _possible_customer_file_name_list.size()
	_previously_selected_customers.append(random_index)
	_set_customer_by_index(random_index)

func _set_next_customer() -> void:
	var next_customer_index = (
		(_current_customer_index + 1)
		% _possible_customer_file_name_list.size()
	)
	_set_customer_by_index(next_customer_index)

func _set_purchase_backpack_contents(column_backpack : Backpack) -> void:
	var worth_silver_coin = TradeEvaluateSelectors.get_worth_silver_coin(
		column_backpack,
		_customer
	)

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
		_set_random_customer()
		content_actions_complete.emit()
		return

	_set_purchase_backpack_contents(column_backpack)

	_set_random_customer()
	content_actions_complete.emit()
