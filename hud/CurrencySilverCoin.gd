# Shared component to show the player's number of silver coins collected.
class_name CurrencySilverCoin extends HBoxContainer

@onready var database = get_node("/root/Database")

var coin_center_position : Vector2 :
	get:
		return $SilverCoin/CoinCenter.global_position

var _coin_display_number : int :
	set(new_value):
		_coin_display_number = new_value 
		$Amount.text = str(new_value)

var _display_number_tween : Tween

func _ready():
	_start_display_number_tween(database.silver_coin_count)
	_display_number_tween.custom_step(100)

	_sync_silver_coin_count()
	database.connect("updated_silver_coin_count", _on_updated_silver_coin_count)

func _on_updated_silver_coin_count() -> void:
	_start_display_number_tween(database.silver_coin_count)

func _sync_silver_coin_count() -> void:
	_start_display_number_tween(database.silver_coin_count)

func _start_display_number_tween(new_coin_value : int) -> void:
	if _display_number_tween != null && _display_number_tween.is_running():
		_display_number_tween.stop()

	_display_number_tween = create_tween()
	_display_number_tween.set_ease(Tween.EASE_OUT)
	_display_number_tween.set_trans(Tween.TRANS_QUAD)
	_display_number_tween.tween_property(self, "_coin_display_number", new_coin_value, 1)
