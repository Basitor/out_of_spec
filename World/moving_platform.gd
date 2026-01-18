extends AnimatableBody2D

@export var SPEED: float = 20.0
@onready var marker_2d: Marker2D = $Marker2D

var start_pos: Vector2
var target_pos: Vector2
var forward := true

func _ready() -> void:
	start_pos = global_position
	target_pos = marker_2d.global_position

func _physics_process(delta: float) -> void:
	var to := target_pos if forward else start_pos
	var prev := global_position

	global_position = global_position.move_toward(to, SPEED * delta)
	var motion := global_position - prev

	move_and_collide(motion)

	if global_position.distance_to(to) < 1.0:
		forward = not forward
