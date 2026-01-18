extends Area2D

@export_multiline var text: String = "NO_TEXT"

func _on_body_entered(_body: Node2D) -> void:
	Globals.earh_achievement(text)
