# Defines logical unit Region as a Resource with properties.
extends Resource

class_name Region

@export var name : String = ""
@export var graphic : Texture2D

@export var possible_items : Array[Item] = []
# can add other qualities that all items will have here
