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
	AlternateTradeEvaluateSelectors.cost_ten_total,
	AlternateTradeEvaluateSelectors.cost_five_single_element.bind(GlobalConstants.Elements.NATURE),
	AlternateTradeEvaluateSelectors.cost_five_single_element.bind(GlobalConstants.Elements.EARTH),
	AlternateTradeEvaluateSelectors.cost_five_single_element.bind(GlobalConstants.Elements.FIRE),
	AlternateTradeEvaluateSelectors.cost_five_single_element.bind(GlobalConstants.Elements.WATER),
	AlternateTradeEvaluateSelectors.cost_five_single_element.bind(GlobalConstants.Elements.AIR),
]

static var tier_3_cost_func : Array[Callable] = [
	AlternateTradeEvaluateSelectors.cost_three_unique_negative_elements,
	AlternateTradeEvaluateSelectors.cost_eight_items,
	AlternateTradeEvaluateSelectors.cost_two_major_elements.bind(GlobalConstants.Elements.NATURE, GlobalConstants.Elements.FIRE),
	AlternateTradeEvaluateSelectors.cost_two_major_elements.bind(GlobalConstants.Elements.EARTH, GlobalConstants.Elements.WATER),
	AlternateTradeEvaluateSelectors.cost_two_major_elements.bind(GlobalConstants.Elements.FIRE, GlobalConstants.Elements.AIR),
	AlternateTradeEvaluateSelectors.cost_two_major_elements.bind(GlobalConstants.Elements.WATER, GlobalConstants.Elements.NATURE),
	AlternateTradeEvaluateSelectors.cost_two_major_elements.bind(GlobalConstants.Elements.AIR, GlobalConstants.Elements.EARTH),
]

static var tier_1_display_func : Array[Callable] = [
	AlternateTradeEvaluateSelectors.description_three_unique_elements,
	AlternateTradeEvaluateSelectors.description_at_least_two_items,
	AlternateTradeEvaluateSelectors.description_three_of_a_kind
]

static var tier_2_display_func : Array[Callable] = [
	AlternateTradeEvaluateSelectors.description_ten_total,
	AlternateTradeEvaluateSelectors.description_five_single_element.bind(GlobalConstants.Elements.NATURE),
	AlternateTradeEvaluateSelectors.description_five_single_element.bind(GlobalConstants.Elements.EARTH),
	AlternateTradeEvaluateSelectors.description_five_single_element.bind(GlobalConstants.Elements.FIRE),
	AlternateTradeEvaluateSelectors.description_five_single_element.bind(GlobalConstants.Elements.WATER),
	AlternateTradeEvaluateSelectors.description_five_single_element.bind(GlobalConstants.Elements.AIR),
]

static var tier_3_display_func : Array[Callable] = [
	AlternateTradeEvaluateSelectors.description_three_unique_negative_elements,
	AlternateTradeEvaluateSelectors.description_eight_items,
	AlternateTradeEvaluateSelectors.description_two_major_elements.bind(GlobalConstants.Elements.NATURE, GlobalConstants.Elements.FIRE),
	AlternateTradeEvaluateSelectors.description_two_major_elements.bind(GlobalConstants.Elements.EARTH, GlobalConstants.Elements.WATER),
	AlternateTradeEvaluateSelectors.description_two_major_elements.bind(GlobalConstants.Elements.FIRE, GlobalConstants.Elements.AIR),
	AlternateTradeEvaluateSelectors.description_two_major_elements.bind(GlobalConstants.Elements.WATER, GlobalConstants.Elements.NATURE),
	AlternateTradeEvaluateSelectors.description_two_major_elements.bind(GlobalConstants.Elements.AIR, GlobalConstants.Elements.EARTH),
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
		return 15 * reward_multiplier
	return 0

static func description_three_unique_elements(
	reward_multiplier : int = 1
) -> OfferDescription:
	var description : OfferDescription = OfferDescription.new()
	description.wants_description = "Three unique elements"
	description.reward_description = str(15 * reward_multiplier)
	return description

static func cost_at_least_two_items(
	backpack : Backpack,
	reward_multiplier : int = 1,
) -> int:
	if backpack._contained_items.size() >= 2:
		return 20 * reward_multiplier
	return 0

static func description_at_least_two_items(
	reward_multiplier : int = 1
) -> OfferDescription:
	var description : OfferDescription = OfferDescription.new()
	description.wants_description = "Two items"
	description.reward_description = str(20 * reward_multiplier)
	return description

static func cost_three_of_a_kind(
	backpack : Backpack,
	reward_multiplier : int = 1,
) -> int:
	if _get_highest_element_value(backpack) >= 3:
		return 15 * reward_multiplier
	return 0

static func description_three_of_a_kind(
	reward_multiplier : int = 1
) -> OfferDescription:
	var description : OfferDescription = OfferDescription.new()
	description.wants_description = "Three of a single element"
	description.reward_description = str(15 * reward_multiplier)
	return description

#################
# TIER 2 OFFERS #
#################
static func cost_ten_total(
	backpack : Backpack,
	reward_multiplier : int = 1,
) -> int:
	if _get_total_element_count(backpack) >= 10:
		return 40 * reward_multiplier
	return 0

static func description_ten_total(
	reward_multiplier : int = 1
) -> OfferDescription:
	var description : OfferDescription = OfferDescription.new()
	description.wants_description = "Ten Elements (total)"
	description.reward_description = str(40 * reward_multiplier)
	return description

static func cost_five_single_element(
	backpack : Backpack,
	reward_multiplier : int,
	bind_element : GlobalConstants.Elements
) -> int:
	if backpack.get_elements()[bind_element] >= 5:
		return 35 * reward_multiplier
	return 0
	
static func description_five_single_element(
	reward_multiplier : int,
	bind_element : GlobalConstants.Elements
) -> OfferDescription:
	var description : OfferDescription = OfferDescription.new()
	description.wants_description = "Five " + str(GlobalConstants.Elements.find_key(bind_element))
	description.reward_description = str(35 * reward_multiplier)
	return description

#################
# TIER 3 OFFERS #
#################
static func cost_three_unique_negative_elements(
	backpack : Backpack,
	reward_multiplier : int = 1,
) -> int:
	if _get_unique_negative_element_count(backpack) >= 3:
		return 100 * reward_multiplier
	return 0

static func description_three_unique_negative_elements(
	reward_multiplier : int = 1
) -> OfferDescription:
	var description : OfferDescription = OfferDescription.new()
	description.wants_description = "Three Unique Negative Elements"
	description.reward_description = str(100 * reward_multiplier)
	return description
	
static func cost_eight_items(
	backpack : Backpack,
	reward_multiplier : int = 1,
) -> int:
	if backpack._contained_items.size() >= 8:
		return 115 * reward_multiplier
	return 0

static func description_eight_items(
	reward_multiplier : int = 1
) -> OfferDescription:
	var description : OfferDescription = OfferDescription.new()
	description.wants_description = "Eight items"
	description.reward_description = str(115 * reward_multiplier)
	return description

static func cost_two_major_elements(
	backpack : Backpack,
	reward_multiplier : int,
	bind_element_1 : GlobalConstants.Elements,
	bind_element_2 : GlobalConstants.Elements
) -> int:
	if backpack.get_elements()[bind_element_1] >= 10 \
			and backpack.get_elements()[bind_element_2] >= 6:
		return 85 * reward_multiplier
	return 0
	
static func description_two_major_elements(
	reward_multiplier : int,
	bind_element_1 : GlobalConstants.Elements,
	bind_element_2 : GlobalConstants.Elements
) -> OfferDescription:
	var description : OfferDescription = OfferDescription.new()
	description.wants_description = "Ten " + str(GlobalConstants.Elements.find_key(bind_element_1))
	description.wants_description += " and Six " + str(GlobalConstants.Elements.find_key(bind_element_2))
	description.reward_description = str(85 * reward_multiplier)
	return description

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

static func _get_total_element_count(column_backpack : Backpack) -> int:
	var backpack_elements = column_backpack.get_elements()
	return backpack_elements.reduce(func(number, accum): return number + accum, 0)

static func _get_unique_negative_element_count(column_backpack : Backpack) -> int:
	var backpack_elements = column_backpack.get_elements()
	return (
		backpack_elements
			.filter(func(number): return number < 0)
			.size()
	)
