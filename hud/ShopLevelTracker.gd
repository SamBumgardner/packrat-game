# Shared component to show the current in-game number of days passed.
extends HBoxContainer

func _ready():
	_sync_shop_level()
	Database.connect("updated_shop_level", _sync_shop_level)

func _sync_shop_level() -> void:
	$LevelNumber.text = str(Database.shop_level)
