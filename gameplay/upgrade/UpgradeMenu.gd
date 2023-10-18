extends Control

@onready var upgrade_manager : UpgradeManager = $UpgradeManager
@onready var _upgrade_buttons : Array[Node] = $UpgradeOptions.get_children() 

# Called when the node enters the scene tree for the first time.
func _ready():
	Database.updated_silver_coin_count.connect(_on_money_or_level_changed)
	Database.set_silver_coin_count(100)

func _on_money_or_level_changed():
	for upgrade_type in UpgradeManager.UpgradeType.values():
		var restricted_reason : UpgradeManager.RestrictedReason = upgrade_manager.can_buy(upgrade_type)
		_upgrade_buttons[upgrade_type].disabled = restricted_reason != UpgradeManager.RestrictedReason.NONE

func _on_show_hide_button_button_down():
	$UpgradeOptions.visible = !$UpgradeOptions.visible
