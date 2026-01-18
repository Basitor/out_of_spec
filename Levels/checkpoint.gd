extends Area2D

@onready var spawn_point: Marker2D = $SpawnPoint

signal player_entered(spawn_point: Vector2)

func _on_body_entered(_body: Node2D) -> void:
	print(_body, " entered check")
	player_entered.emit(spawn_point.global_position)
