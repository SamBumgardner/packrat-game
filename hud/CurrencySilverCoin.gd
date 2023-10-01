extends HBoxContainer

@onready var database = get_node("/root/Database")

func _ready():
	$Amount.text = str(database.silver_coin_count)

func _process(delta):
	$Amount.text = str(database.silver_coin_count)
