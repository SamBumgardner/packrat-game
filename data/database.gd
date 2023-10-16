# Defines variables shared across scenes with the correct data types.
extends Node

signal updated_day_count
signal updated_silver_coin_count
signal updated_trade_count

var _initial_day_count : int = 1
var _initial_silver_coin_count : int = 0
var _initial_trade_count : int = 0

var day_count : int
var silver_coin_count : int
var trade_count : int

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

	set_silver_coin_count(_initial_silver_coin_count)

	trade_count = _initial_trade_count

func set_silver_coin_count(updated_count : int) -> void:
	silver_coin_count = updated_count
	updated_silver_coin_count.emit()
