# Encapsulate selector functions for determing if a backpack's contents will
#  be accepted by a customer, and for many Silver Coins in reward.
class_name AlternateTradeEvaluateSelectors

static var customer_tier_multipliers : Array[int] = [
	1,
	2,
	3,
	5
]

static var tier_1_cost_func : Array[Callable] = [
	AlternateTradeEvaluateSelectors.cost_three_unique_elements,
	AlternateTradeEvaluateSelectors.cost_at_least_two_items,
	AlternateTradeEvaluateSelectors.cost_three_of_a_kind,
]

static var tier_2_cost_func : Array[Callable] = [
	AlternateTradeEvaluateSelectors.tier_2_placeholder
]

static var tier_3_cost_func : Array[Callable] = [
	AlternateTradeEvaluateSelectors.tier_3_placeholder
]

static var tier_1_display_func : Array[Callable] = [
	AlternateTradeEvaluateSelectors.description_three_unique_elements,
	AlternateTradeEvaluateSelectors.description_at_least_two_items,
	AlternateTradeEvaluateSelectors.description_three_of_a_kind
]

static var tier_2_display_func : Array[Callable] = [
	AlternateTradeEvaluateSelectors.tier_2_placeholder
]

static var tier_3_display_func : Array[Callable] = [
	AlternateTradeEvaluateSelectors.tier_3_placeholder
]

static var cost_func : Array[Array] = [
	tier_1_cost_func,
	tier_2_cost_func,
	tier_3_cost_func
]

static var display_func : Array[Array] = [
	tier_1_display_func,
	tier_2_display_func,
	tier_3_display_func
]

class OfferDescription extends RefCounted:
	var wants_description : String = ""
	var reward_description : String = ""

####################
# PUBLIC FUNCTIONS #
####################

static func calculate_offer_cost(
	backpack : Backpack,
	customer_tier : int,
	offer_tier : int,
	trade_offer_enum : int
) -> int:
	var reward_multiplier_index = customer_tier - offer_tier
	var multiplier = customer_tier_multipliers[reward_multiplier_index]
	return cost_func[offer_tier][trade_offer_enum].call(backpack, multiplier)

static func get_offer_description(
	customer_tier : int,
	offer_tier : int,
	trade_offer_enum : int
) -> OfferDescription:
	var reward_multiplier_index = customer_tier - offer_tier
	var multiplier = customer_tier_multipliers[reward_multiplier_index]
	return display_func[offer_tier][trade_offer_enum].call(multiplier)

#################
# TIER 1 OFFERS #
#################
static func cost_three_unique_elements(
	backpack : Backpack,
	reward_multiplier : int = 1
) -> int:
	if _get_unique_element_count(backpack) >= 3:
		return 10 * reward_multiplier
	return 0

static func description_three_unique_elements(
	reward_multiplier : int = 1
) -> OfferDescription:
	var description : OfferDescription = OfferDescription.new()
	description.wants_description = "Three unique elements"
	description.reward_description = str(10 * reward_multiplier)
	return description

static func cost_at_least_two_items(
	backpack : Backpack,
	reward_multiplier : int = 1,
) -> int:
	if backpack._contained_items.size() >= 2:
		return 15 * reward_multiplier
	return 0

static func description_at_least_two_items(
	reward_multiplier : int = 1
) -> OfferDescription:
	var description : OfferDescription = OfferDescription.new()
	description.wants_description = "Two items"
	description.reward_description = str(15 * reward_multiplier)
	return description

static func cost_three_of_a_kind(
	backpack : Backpack,
	reward_multiplier : int = 1,
) -> int:
	if _get_highest_element_value(backpack) >= 3:
		return 10 * reward_multiplier
	return 0

static func description_three_of_a_kind(
	reward_multiplier : int = 1
) -> OfferDescription:
	var description : OfferDescription = OfferDescription.new()
	description.wants_description = "Three of a single element"
	description.reward_description = str(10 * reward_multiplier)
	return description

#################
# TIER 2 OFFERS #
#################
static func tier_2_placeholder(
	backpack : Backpack,
	reward_multiplier : int = 1,
) -> int:
	return 30

#################
# TIER 3 OFFERS #
#################
static func tier_3_placeholder(
	backpack : Backpack,
	reward_multiplier : int = 1,
) -> int:
	return 55

#####################
# PRIVATE FUNCTIONS #
#####################
static func _get_unique_element_count(column_backpack : Backpack) -> int:
	var backpack_elements = column_backpack.get_elements()
	return (
		backpack_elements
			.filter(func(number): return number > 0)
			.size()
	)

static func _get_highest_element_value(column_backpack : Backpack) -> int:
	var backpack_elements = column_backpack.get_elements()
	return backpack_elements.reduce(func(number, accum): return max(number, accum), 0)
