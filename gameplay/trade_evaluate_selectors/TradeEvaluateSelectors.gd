# Encapsulate selector functions for determing if a backpack's contents will
#  be accepted by a customer, and for many Silver Coins in reward.
class_name TradeEvaluateSelectors

####################
# PUBLIC FUNCTIONS #
####################
# Returns true if the current customer will buy the backpack's contents.
static func get_wants_backpack(
	backpack : Backpack,
	customer : Customer
) -> bool:
	if customer == null or not _get_has_backpack(backpack):
		return false

	return _get_has_at_least_one_element(backpack)

static func get_worth_silver_coin(
	backpack : Backpack,
	customer : Customer
) -> int:
	if (
		customer.trade_formula
		== GlobalConstants.TradeFormula.COUNT_UNIQUE_ELEMENTS
	):
		# Default formula.
		var backpack_elements = backpack.get_elements()
		return _get_unique_element_count(backpack)

	if (
		customer.trade_formula
		== GlobalConstants.TradeFormula.PAIR_OF_UNIQUE
	):
		var trade_formula_divisor = 2
		var trade_formula_reward_multiplier = 5

		var backpack_elements = backpack.get_elements()
		var trade_formula_matches = floor(
			_get_unique_element_count(backpack)
			/ trade_formula_divisor
		)
		return trade_formula_matches * trade_formula_reward_multiplier

	if (
		customer.trade_formula
		== GlobalConstants.TradeFormula.THREE_OF_A_KIND
	):
		var trade_formula_filter_element_minimum = 3
		var trade_formula_reward_multiplier = 25

		var backpack_elements = backpack.get_elements()
		var element_type_matches = backpack_elements.filter(
			func(element : int): return (
				element >= trade_formula_filter_element_minimum
			)
		)
		var trade_formula_matches = element_type_matches.size()
		return trade_formula_matches * trade_formula_reward_multiplier

	# Default formula.
	var backpack_elements = backpack.get_elements()
	return _get_unique_element_count(backpack)

#####################
# PRIVATE FUNCTIONS #
#####################
static func _get_has_backpack(column_backpack : Backpack):
	return column_backpack != null

static func _get_has_at_least_one_element(column_backpack : Backpack):
	return _get_unique_element_count(column_backpack) > 0

static func _get_unique_element_count(column_backpack : Backpack) -> int:
	var backpack_elements = column_backpack.get_elements()
	return (
		backpack_elements
			.filter(func(number): return number > 0)
			.size()
	)
