extends CharacterBody2D

@onready var particles: GPUParticles2D = $Particles

@export var speed = 100
@export var appear: bool = true

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label


var disabled: bool = false

func _ready() -> void:
	label.call_deferred("reparent", get_tree().current_scene)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta):
	particles.global_position = global_position
	
	if animation_player.is_playing(): return
	if not disabled:
		get_input()
	else:
		if Globals.player and global_position.distance_to(Globals.player.global_position) > 10:
			velocity = global_position.direction_to(Globals.head.global_position) * (speed * 0.5)
		else:
			velocity = Vector2.ZERO

	move_and_slide()


func disable(value: bool = true):
	if value:
		disabled = value
		collision_layer = 0
		collision_mask = 0
	else:
		disabled = false
		collision_layer = 0
		collision_mask = 0
