# Defines variables shared across scenes with the correct data types.
extends Node

var _initial_day_count = 1
var _initial_silver_coin_count = 0

var day_count
var silver_coin_count


func _ready():
	reset_values()


func increment_day_count():
	day_count += 1

func reset_values():
	day_count = _initial_day_count
	silver_coin_count = _initial_silver_coin_count
