# Customers may buy from the backpack assigned to them.
# Currently, all customers buy everything at a rate of 1 Silver Coin per unique
#  element.
class_name CustomerContents

extends ColumnContents

@onready var database = get_node("/root/Database")

@onready var _fly_from_pack_to_customer_graphic : Sprite2D = (
	$Contents/ItemGraphicControl/FlyToPackItem
)
@onready var _tween_fly_from_pack_to_customer : Tween = create_tween()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_cannot_buy(column_backpack : Backpack):
	return (
		not _get_has_backpack(column_backpack)
		or not _get_wants_backpack(column_backpack)
	)

func _get_has_backpack(column_backpack : Backpack):
	return column_backpack != null

func _get_unique_element_count(column_backpack : Backpack) -> int:
	var backpack_elements = column_backpack.get_elements()
	return (
		backpack_elements
			.filter(func(number): return number > 0)
			.size()
	)

func _get_wants_backpack(column_backpack : Backpack) -> bool:
	if not _get_has_backpack(column_backpack):
		return false

	var backpack_elements = column_backpack.get_elements()
	return not backpack_elements.is_empty() and backpack_elements.size() > 0

func _get_worth_silver_coin(column_backpack : Backpack) -> int:
	var backpack_elements = column_backpack.get_elements()
	return _get_unique_element_count(column_backpack)

func _set_purchase_backpack_contents(column_backpack : Backpack) -> void:
	var worth_silver_coin = _get_worth_silver_coin(column_backpack)

	column_backpack.remove_items()
	database.set_silver_coin_count(
		database.silver_coin_count
		+ worth_silver_coin
	)

#####################
# NEXT DAY HANDLING #
#####################
func next_day(column_backpack : Backpack) -> void:
	if (_get_cannot_buy(column_backpack)):
		content_actions_complete.emit()
		return

	_set_purchase_backpack_contents(column_backpack)

	_trigger_tween_fly_from_pack_to_customer(column_backpack)

func _trigger_tween_fly_from_pack_to_customer(target_pack : Backpack):
	_tween_fly_from_pack_to_customer = create_tween()
	_tween_fly_from_pack_to_customer = (
		CustomerContentsTweens.init_tween_fly_from_pack_to_customer(
			_tween_fly_from_pack_to_customer, 
			_fly_from_pack_to_customer_graphic, 
			target_pack
		)
	)

	_tween_fly_from_pack_to_customer.connect(
		"finished",
		emit_signal.bind("content_actions_complete")
	)
	_tween_fly_from_pack_to_customer.play()
