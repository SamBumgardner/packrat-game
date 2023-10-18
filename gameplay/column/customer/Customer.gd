# Defines logical unit Customer as a Resource with properties.
extends Resource

class_name Customer

@export var graphic : Texture2D
@export var name : String = ""
@export var trade_formula : GlobalConstants.TradeFormula = (
	GlobalConstants.TradeFormula.COUNT_UNIQUE_ELEMENTS
)
