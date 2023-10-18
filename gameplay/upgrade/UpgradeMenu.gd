extends Control

signal upgrade_selected

const UPGRADE_BUTTON_SCENE : PackedScene = preload("res://gameplay/upgrade/UpgradeButton.tscn")

@export var upgrade_button_names : Array[String] = [
	"New Bag",
	"Expand Shop",
	"Increase Bag Space",
	"Remodel Space for Gathering",
	"Remodel Space for Customers",
	"Empty Space",
	"Shop Level Up"
]

@onready var _upgrade_buttons : Array[UpgradeButton] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for upgrade_type in UpgradeManager.UpgradeType.values():
		var new_upgrade_button = UPGRADE_BUTTON_SCENE.instantiate()
		new_upgrade_button.set_upgrade_name(upgrade_button_names[upgrade_type])
		new_upgrade_button.set_cost(UpgradeManager.get_cost(upgrade_type))
		new_upgrade_button.pressed.connect(_on_button_pressed.bind(upgrade_type))
		$UpgradeOptions.add_child(new_upgrade_button)
		_upgrade_buttons.append(new_upgrade_button)
	Database.updated_silver_coin_count.connect(_on_money_or_level_changed)

func _on_money_or_level_changed():
	for upgrade_type in UpgradeManager.UpgradeType.values():
		var restricted_reason : UpgradeManager.RestrictedReason = UpgradeManager.check_restricted(upgrade_type)
		if restricted_reason != UpgradeManager.RestrictedReason.NONE:
			_upgrade_buttons[upgrade_type].disable_with_reason(restricted_reason)
		else:
			_upgrade_buttons[upgrade_type].enable()

func _on_show_hide_button_button_down():
	$UpgradeOptions.visible = !$UpgradeOptions.visible

func _on_button_pressed(upgrade_type : UpgradeManager.UpgradeType) -> void:
	upgrade_selected.emit(upgrade_type)
