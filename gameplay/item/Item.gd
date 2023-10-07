extends Resource

class_name Item

@export var name:String = ""
@export var graphic:Texture2D

@export var ele_nature:int = 0
@export var ele_earth:int = 0
@export var ele_fire:int = 0
@export var ele_water:int = 0
@export var ele_air:int = 0
@export var ele_wild:int = 0

@export var elements:Array[int] = [0, 0, 0, 0, 0, 0]
# can add other qualities that all items will have here
