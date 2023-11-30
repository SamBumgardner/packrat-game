# Shared component to show the player's number of silver coins collected.
class_name CurrencySilverCoin extends HBoxContainer

@onready var database = get_node("/root/Database")

var coin_center_position : Vector2 :
	get:
		return $SilverCoin/CoinCenter.global_position

func _ready():
	_sync_silver_coin_count()
	database.connect("updated_silver_coin_count", _on_updated_silver_coin_count)

func _on_updated_silver_coin_count() -> void:
	$Amount.text = str(database.silver_coin_count)

func _sync_silver_coin_count() -> void:
	$Amount.text = str(database.silver_coin_count)
