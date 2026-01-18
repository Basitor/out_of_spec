extends Area2D

signal crystal_collected

@onready var crystal_animation: AnimationPlayer = $Crystal


@export var SPEED: float = 20.0
@export var move_to_player: bool = false

func _on_body_entered(_body: Node2D) -> void:
	collision_layer = false
	collision_mask = false
	crystal_animation.play("float")
	crystal_collected.emit()
	
func _process(delta: float) -> void:
	if move_to_player:
		if Globals.player and global_position.distance_to(Globals.player.global_position) > 10:
			global_position += global_position.direction_to(Globals.player.global_position) * SPEED * delta
		
