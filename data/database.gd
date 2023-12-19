# Defines variables shared across scenes with the correct data types.
extends Node

signal updated_day_count
signal updated_shop_level
signal updated_silver_coin_count(is_initial_value : bool)
signal updated_trade_count

var _initial_day_count : int = 1
var _initial_silver_coin_count : int = 45
var _initial_trade_count : int = 0
var _initial_backpacks_purchased : int = 0
var _initial_columns_purchased : int = 0
var _initial_capacity_increases_purchased : int = 0
var _initial_active_region_columns = 0
var _initial_active_customer_columns = 0
var _initial_shop_level = 0

var day_count : int
var silver_coin_count : int
var trade_count : int

var backpacks_purchased : int = 0
var columns_purchased : int = 0
var capacity_increases_purchased : int = 0
var active_region_columns = 0
var active_customer_columns = 0
var shop_level = 0

func _ready():
	reset_values()

func increment_day_count() -> void:
	day_count += 1
	updated_day_count.emit()

func increment_trade_count() -> void:
	trade_count += 1
	updated_trade_count.emit()

func reset_values() -> void:
	day_count = _initial_day_count
	updated_day_count.emit()

	set_silver_coin_count(_initial_silver_coin_count, true)

	trade_count = _initial_trade_count
	
	backpacks_purchased = _initial_backpacks_purchased
	columns_purchased = _initial_columns_purchased
	capacity_increases_purchased = _initial_capacity_increases_purchased
	active_region_columns = _initial_active_region_columns
	active_customer_columns = _initial_active_customer_columns
	shop_level = _initial_shop_level
	updated_shop_level.emit()

func set_silver_coin_count(updated_count : int, is_initial_value : bool = false) -> void:
	silver_coin_count = updated_count
	updated_silver_coin_count.emit(is_initial_value)

func set_shop_level(updated_level : int) -> void:
	shop_level = updated_level
	updated_shop_level.emit()
