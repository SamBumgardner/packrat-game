class_name AlternateTradeOffer

extends VBoxContainer

@onready var _bonus_description : Label = $BonusDescription
@onready var _reward_description : Label = $RewardDescription
@onready var _wants_description : RichTextLabel = $WantsDescription

var _offer_tier : int = 0
var _trade_offer_index : int = 0

func _ready():
	_update_display()

func _populate_text_from_trade_formula_enum() -> void:
	var offer_description : AlternateTradeEvaluateSelectors.OfferDescription = AlternateTradeEvaluateSelectors.get_offer_description(
		Database.shop_level, 
		_offer_tier, 
		_trade_offer_index
	)
	
	_wants_description.text = offer_description.wants_description
	_bonus_description.text = ""
	_reward_description.text = offer_description.reward_description + " Silver Coins"

func set_trade_formula(offer_tier : int, trade_offer_index : int) -> void:
	_offer_tier = offer_tier
	_trade_offer_index = trade_offer_index
	_update_display()

func _show_only_filled_text() -> void:
	_wants_description.visible = _wants_description.text != ""
	_bonus_description.visible = _bonus_description.text != ""
	_reward_description.visible = _reward_description.text != ""

func _update_display() -> void:
	_populate_text_from_trade_formula_enum()
	_show_only_filled_text()
