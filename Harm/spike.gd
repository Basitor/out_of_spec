extends Area2D

@export var SPEED: float = 400.0
@export var ACCEL: float = 600.0
@export var hang: bool = false

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var falling_ray: RayCast2D = $FallingRay

@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var collision_shape_area: CollisionShape2D = $CollisionShapeArea
@onready var collision_shape_body: CollisionShape2D = $StaticBody2D/CollisionShapeBody


var current_speed: float = 0

func _ready() -> void:
	collision_shape_body.shape = collision_shape_area.shape

func _physics_process(delta: float) -> void:
	if hang:
		if falling_ray.is_colliding():
			hang = false
		else:
			return
	if ray_cast_2d.is_colliding():
		collision_layer = 0
		static_body_2d.collision_layer = 2
		return
	
	collision_layer = 4
	current_speed = min(current_speed, SPEED)
	position.y += current_speed * delta
	current_speed += ACCEL * delta
