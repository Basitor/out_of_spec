extends Area2D

@export var SPEED: float = 400.0
@export var ACCEL: float = 600.0
@export var hang: bool = false

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var falling_ray: RayCast2D = $FallingRay
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var collision_shape_area: CollisionShape2D = $CollisionShapeArea
@onready var collision_shape_body: CollisionShape2D = $StaticBody2D/CollisionShapeBody


var current_speed: float = 0
var is_static: bool = false:
	set(value):
		if value == is_static:
			return
		is_static = value
		if value:
			collision_layer = 0
			static_body_2d.collision_layer = 2
			audio_stream_player_2d.play()
		else:
			collision_layer = 4
			static_body_2d.collision_layer = 0

func _ready() -> void:
	collision_shape_body.shape = collision_shape_area.shape

func _physics_process(delta: float) -> void:
	if hang:
		if falling_ray.is_colliding():
			hang = false
		else:
			return
	
	if ray_cast_2d.is_colliding():
		is_static = true
	else:
		is_static = false

	if not is_static:
		current_speed = min(current_speed, SPEED)
		position.y += current_speed * delta
		current_speed += ACCEL * delta
