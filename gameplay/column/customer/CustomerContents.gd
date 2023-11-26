# Customers may buy from the backpack assigned to them.
# Currently, all customers buy everything at a rate of 1 Silver Coin per unique
#  element.
class_name CustomerContents

extends ColumnContents

const _customer_data_folder_path = "res://data/customers/"
const _default_customer_index = 0
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

static var _previously_selected_customers : Array[int] = []

@export var _customer : Customer = null

var header_name : String = ""

var _current_customer_file_name = _possible_customer_file_name_list[
	_default_customer_index
]
var _current_customer_index = _default_customer_index

var _current_offer_tier : int = 0
var _current_offer_trade_enum_value : int = 0

var _is_talking_to_customer : bool = false

@onready var database = get_node("/root/Database")
@onready var trade_offer = $TradeOffer2

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_random_customer()
	set_header_properties(_customer.graphic, _customer.name)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _build_customer_file_path(file_name : String) -> String:
	return _customer_data_folder_path + file_name

func _get_offer_value(column_backpack : Backpack):
	return AlternateTradeEvaluateSelectors.calculate_offer_cost( 
		column_backpack,
		Database.shop_level,
		_current_offer_tier,
		_current_offer_trade_enum_value
	)

func _get_cannot_buy(column_backpack : Backpack):
	if column_backpack == null or 0 >= _get_offer_value(column_backpack):
		return true

# Sets the active customer.
# Assumes a previous method call is keeping track of the random queue of
#  customers.
func _set_customer(new_customer : Customer) -> void:
	_customer = new_customer
	header_name = _customer.name
	set_header_properties(_customer.graphic, _customer.name)
	_select_trade_offer()

func _select_random_offer_tier(shop_level : int) -> int:
	var tier_roll : int = randi() % 100
	var selected_tier = 0 
	match shop_level:
		0:
			selected_tier = 0
		1:
			if tier_roll >= 75:
				selected_tier = 1
			else:
				selected_tier = 0
		2:
			if tier_roll >= 50:
				selected_tier = 1
			else:
				selected_tier = 0
		3:
			if tier_roll >= 20 and tier_roll < 60:
				selected_tier = 1
			elif tier_roll >= 60:
				selected_tier = 2
			else:
				selected_tier = 0
		_: 
			selected_tier = 2
	return selected_tier

func _select_trade_offer() -> void:
	_current_offer_tier = _select_random_offer_tier(Database.shop_level)
	match _current_offer_tier:
		0:
			_current_offer_trade_enum_value = GlobalConstants.TIER_1_TRADE_OFFERS.values().pick_random()
		1:
			_current_offer_trade_enum_value = GlobalConstants.TIER_2_TRADE_OFFERS.values().pick_random()
		2:
			_current_offer_trade_enum_value = GlobalConstants.TIER_3_TRADE_OFFERS.values().pick_random()
	
	trade_offer.set_trade_formula(_current_offer_tier, _current_offer_trade_enum_value)

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
	var worth_silver_coin = _get_offer_value(column_backpack)

	column_backpack.remove_items()
	database.set_silver_coin_count(
		database.silver_coin_count
		+ worth_silver_coin
	)
	database.increment_trade_count()

func attempt_alternate_action(column_backpack : Backpack) -> void:
	if column_backpack == null:
		_is_talking_to_customer = !_is_talking_to_customer
		var new_status = GlobalConstants.ColumnStatus.CUSTOMER_TALK if _is_talking_to_customer else GlobalConstants.ColumnStatus.NONE
		content_status_change.emit(new_status)

func _on_column_backpack_set(new_column_backpack : Backpack) -> void:
	if _is_talking_to_customer:
		_is_talking_to_customer = false
		content_status_change.emit(GlobalConstants.ColumnStatus.NONE)

#####################
# NEXT DAY HANDLING #
#####################
func next_day(column_backpack : Backpack) -> void:
	if not _is_talking_to_customer:
		if _get_cannot_buy(column_backpack):
			_set_random_customer()
		else:
			_set_purchase_backpack_contents(column_backpack)
			_set_random_customer()
	
	content_actions_complete.emit()
