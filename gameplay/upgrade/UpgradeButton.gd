class_name UpgradeButton

extends Button

const COIN_TEXTURE = preload("res://art/silver_coin.png")
const LEVEL_TEXTURE = preload("res://art/level_up.png")

const SHOP_LEVEL_TIP = "Shop Level isn't high enough yet"
const COST_TIP = "Don't have enough coins"

@export var upgrade_name : String = "Upgrade_Name"
@export var cost : int = 0

func set_upgrade_name(new_name : String) -> void:
	upgrade_name = new_name
	if cost < 0:
		text = upgrade_name + ": Appropriate Refund"
	else:
		text = upgrade_name + ": " + str(cost)

func set_cost(new_cost : int):
	cost = new_cost
	if cost < 0:
		text = upgrade_name + ": Appropriate Refund"
	else:
		text = upgrade_name + ": " + str(cost)

func disable_with_reason(reason : UpgradeManager.RestrictedReason) -> void:
	disabled = true
	match reason:
		UpgradeManager.RestrictedReason.COST:
			$Control.show()
			$Control/DisabledReasonSprite.texture = COIN_TEXTURE
			$Control/DisabledReasonSprite.modulate = Color.RED
			tooltip_text = COST_TIP
		UpgradeManager.RestrictedReason.SHOP_LEVEL:
			$Control.show()
			$Control/DisabledReasonSprite.texture = LEVEL_TEXTURE
			$Control/DisabledReasonSprite.modulate = Color.WHITE
			tooltip_text = SHOP_LEVEL_TIP
		_:
			$Control.hide()
			tooltip_text = ""

func enable() -> void:
	disabled = false
	$Control.hide()
