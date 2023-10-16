# Abstract class defining the interface of a "gameplay state"
# Tightly coupled to Gameplay.gd
class_name GameplayState

extends RefCounted

func _on_enter(_gameplay : Gameplay) -> void:
	pass

func _on_exit(_gameplay : Gameplay) -> void:
	pass

func process_input(_gameplay : Gameplay, _event : InputEvent) -> Gameplay.State:
	return Gameplay.State.NO_CHANGE
