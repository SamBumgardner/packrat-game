# Component to show the current number of trades successfully made with
#  in-game customers.
extends HBoxContainer

@onready var database = get_node("/root/Database")

func _ready():
	_sync_trade_count()
	database.connect("updated_trade_count", _on_updated_trade_count)

func _on_updated_trade_count() -> void:
	_sync_trade_count()

func _sync_trade_count() -> void:
	$NumberOfTrades.text = str(database.trade_count)
