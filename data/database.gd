# Defines variables shared across scenes with the correct data types.
extends Node

signal updated_day_count
signal updated_silver_coin_count

var _initial_day_count = 1
var _initial_silver_coin_count = 0

var day_count
var silver_coin_count


func _ready():
	reset_values()


func increment_day_count():
	day_count += 1
	updated_day_count.emit()

func reset_values():
	day_count = _initial_day_count
	updated_day_count.emit()

	silver_coin_count = _initial_silver_coin_count
	updated_silver_coin_count.emit()