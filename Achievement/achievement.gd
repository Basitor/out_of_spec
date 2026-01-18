extends CanvasLayer

@export_multiline var text: String = "NO_TEXT"

@onready var label: Label = $Label

var base_text: String = "New achievement\n"

func _ready() -> void:
	label.text = base_text + text
