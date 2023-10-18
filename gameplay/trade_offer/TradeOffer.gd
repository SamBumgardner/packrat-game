class_name TradeOffer

extends VBoxContainer

@onready var _bonus_description : Label = $BonusDescription
@onready var _reward_description : Label = $RewardDescription
@onready var _wants_description : Label = $WantsDescription

var _trade_formula : GlobalConstants.TradeFormula = (
	GlobalConstants.TradeFormula.COUNT_UNIQUE_ELEMENTS
)

func _ready():
	_update_display()

func _build_reward_description(trade_formula_reward_multiplier) -> String:
	var unit_name = "Silver Coin"

	if trade_formula_reward_multiplier != 1:
		unit_name = "Silver Coins"

	return (
		str(trade_formula_reward_multiplier)
		+ " "
		+ unit_name
		+ " each"
	)

func _is_label_missing():
	return (
		_bonus_description == null
		or _reward_description == null
		or _wants_description == null
	)

# Hardcodes trade multipliers of 1, 5, and 25.
func _populate_text_from_trade_formula_enum() -> void:
	if _trade_formula == GlobalConstants.TradeFormula.COUNT_UNIQUE_ELEMENTS:
		var trade_formula_reward_multiplier = 1
		_wants_description.text = "Unique elements"
		_bonus_description.text = ""
		_reward_description.text = _build_reward_description(
			trade_formula_reward_multiplier
		)
		return

	if _trade_formula == GlobalConstants.TradeFormula.PAIR_OF_UNIQUE:
		var trade_formula_reward_multiplier = 5
		_wants_description.text = "2 unique elements"
		_bonus_description.text = ""
		_reward_description.text = _build_reward_description(
			trade_formula_reward_multiplier
		)
		return

	if _trade_formula == GlobalConstants.TradeFormula.THREE_OF_A_KIND:
		var trade_formula_reward_multiplier = 25
		_wants_description.text = "3 same elements"
		_bonus_description.text = ""
		_reward_description.text = _build_reward_description(
			trade_formula_reward_multiplier
		)
		return

	push_warning(
		"Warning: Hiding description because the customer is missing"
		+ " a trade formula."
	)
	_wants_description.text = ""
	_bonus_description.text = ""
	_reward_description.text = ""

func set_trade_formula(trade_formula : GlobalConstants.TradeFormula) -> void:
	_trade_formula = trade_formula
	_update_display()

func _show_only_filled_text() -> void:
	_wants_description.visible = _wants_description.text != ""
	_bonus_description.visible = _bonus_description.text != ""
	_reward_description.visible = _reward_description.text != ""

func _update_display() -> void:
	if _is_label_missing():
		return

	_populate_text_from_trade_formula_enum()
	_show_only_filled_text()
