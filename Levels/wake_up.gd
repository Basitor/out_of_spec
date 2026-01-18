extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(_body: Node2D) -> void:
	collision_layer = 0
	collision_mask = 0
	animation_player.play("wakeup")
