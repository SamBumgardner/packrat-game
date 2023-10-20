# Defines logical unit Region as a Resource with properties.
extends Resource

class_name Region

@export var name : String = ""
@export var graphic : Texture2D

@export var possible_items : Array[Item] = []
@export var modifiers_tier_1 : Array[Modifier] = []
@export var modifiers_tier_2 : Array[Modifier] = []
@export var modifiers_tier_3 : Array[Modifier] = []
# can add other qualities that all items will have here
