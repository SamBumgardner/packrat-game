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

var elements:Array[int] = [ele_nature, ele_earth, ele_fire, ele_water, ele_air, ele_wild]
# can add other qualities that all items will have here
