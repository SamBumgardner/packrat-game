class_name WaitState

extends GameplayState

const busy_mouse_icon : Texture = preload("res://art/hourglass_icon.png")

func _init():
	pass

func _on_enter(gameplay : Gameplay) -> void:
	Input.set_custom_mouse_cursor(busy_mouse_icon)
	gameplay.disable_next_day()

func _on_exit(gameplay : Gameplay) -> void:
	gameplay.enable_next_day()
