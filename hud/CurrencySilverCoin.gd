# Shared component to show the player's number of silver coins collected.
extends HBoxContainer

@onready var database = get_node("/root/Database")

func _ready():
	_sync_silver_coin_count()
	database.connect("updated_silver_coin_count", _on_updated_silver_coin_count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_updated_silver_coin_count():
	$Amount.text = str(database.silver_coin_count)

func _sync_silver_coin_count():
	$Amount.text = str(database.silver_coin_count)
