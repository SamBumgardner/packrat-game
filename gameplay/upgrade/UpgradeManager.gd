class_name UpgradeManager

enum UpgradeType {
	ADD_BACKPACK = 0,
	ADD_COLUMN,
	INCREASE_CAPACITY,
	CHANGE_COLUMN_REGION,
	CHANGE_COLUMN_CUSTOMER,
	EMPTY_COLUMN,
	REMODEL
}

enum RestrictedReason {
	NONE,
	COST,
	SHOP_LEVEL
}

const NO_LIMIT_PER_LEVEL : Array[int] = [100, 100, 100, 100]

static var add_backpack_costs : Array[int] = [50, 75, 100, 150, 200]
static var add_column_costs : Array[int] = [100, 125, 175, 250]
static var increase_capacity_costs : Array[int] = [10, 20, 30, 40, 50, 60]
static var change_column_region_costs : Array[int] = [30]
static var change_column_customer_costs : Array[int] = [30]
static var empty_column_costs : Array[int] = [-30]
static var remodel_costs : Array[int] = [150, 250, 350, 500]

static var add_backpack_level_limits : Array[int] = [2, 3, 4, 6]
static var add_column_level_limits : Array[int] = [3, 4, 5, 6]
static var increase_capacity_level_limits : Array[int] = [3, 4, 5, 6]
static var change_column_region_level_limits : Array[int] = NO_LIMIT_PER_LEVEL
static var change_column_customer_level_limits : Array[int] = NO_LIMIT_PER_LEVEL
static var empty_column_level_limits : Array[int] = NO_LIMIT_PER_LEVEL
static var remodel_level_limits : Array[int] = NO_LIMIT_PER_LEVEL

static var _costs : Array[Array] = [
	add_backpack_costs,
	add_column_costs,
	increase_capacity_costs,
	change_column_region_costs,
	change_column_customer_costs,
	empty_column_costs,
	remodel_costs
]
static var _level_limits : Array[Array] = [
	add_backpack_level_limits,
	add_column_level_limits,
	increase_capacity_level_limits,
	change_column_region_level_limits,
	change_column_customer_level_limits,
	empty_column_level_limits,
	remodel_level_limits
]
static var _count_times_bought : Array[Callable] = [
	func () : return 0,
	func () : return 0,
	func () : return 0,
	func () : return 0,
	func () : return 0,
	func () : return 0,
	func () : return 0,
]

static func get_cost(upgrade_type : UpgradeType) -> int:
	var number_of_times_bought = _count_times_bought[upgrade_type].call()
	return _costs[upgrade_type][number_of_times_bought]

static func check_restricted(upgrade_type : UpgradeType) -> RestrictedReason:
	var current_level = 0 # temp var, should pull this from DB or gameplay
	
	var number_of_times_bought = _count_times_bought[upgrade_type].call()
	var max_number_for_level = _level_limits[upgrade_type][current_level]
	var cost = _costs[upgrade_type][number_of_times_bought]
	if number_of_times_bought >= max_number_for_level:
		return RestrictedReason.SHOP_LEVEL
	elif cost > Database.silver_coin_count:
		return RestrictedReason.COST
	
	return RestrictedReason.NONE
