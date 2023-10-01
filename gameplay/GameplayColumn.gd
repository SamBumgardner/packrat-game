extends Control

var column_index = 1

func _ready():
	$Header/ColumnNumber.text = str(column_index)

func set_column_header_index(index):
	column_index = index
	$Header/ColumnNumber.text = str(column_index)
