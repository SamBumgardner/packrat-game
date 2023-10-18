class_name UpgradeButton

extends Button

const COIN_TEXTURE = preload("res://art/silver_coin.png")
const LEVEL_TEXTURE = preload("res://art/hammer_icon.png")

@export var upgrade_name : String = "Upgrade_Name"
@export var cost : int = 0

func set_upgrade_name(new_name : String) -> void:
	upgrade_name = new_name
	text = upgrade_name + ": " + str(cost)

func set_cost(new_cost : int):
	cost = new_cost
	text = upgrade_name + ": " + str(cost)

func disable_with_reason(reason : UpgradeManager.RestrictedReason) -> void:
	disabled = true
	match reason:
		UpgradeManager.RestrictedReason.COST:
			$Control.show()
			$Control/DisabledReasonSprite.texture = COIN_TEXTURE
			$Control/DisabledReasonSprite.modulate = Color.RED
		UpgradeManager.RestrictedReason.SHOP_LEVEL:
			$Control.show()
			$Control/DisabledReasonSprite.texture = LEVEL_TEXTURE
			$Control/DisabledReasonSprite.modulate = Color.BLUE
		_:
			$Control.hide()

func enable() -> void:
	disabled = false
	$Control.hide()
