extends CharacterBody2D

@export var SPEED: float = 200
@export var ACCEL: float = 20
@export var GRAVITY: float = 400
@export var GRAVITY_ACCEL: float = 15
@export var JUMP_HEIGHT: float = 300
@export var FRICTION: float = 20

@onready var vignette: CanvasLayer = $CanvasLayer
@onready var body: Node2D = $Body
@onready var animation_player: AnimationPlayer = $Body/AnimationPlayer
@onready var head_marker: Marker2D = $HeadMarker
@onready var camera_2d: Camera2D = $Camera2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var death_audio: AudioStreamPlayer = $DeathAudio


signal dead_signal

var is_dead: bool = false:
	set(value):
		is_dead = value
		if value:
			animation_player.play("dead")
			Globals.earh_achievement("Die for the first time")
			death_audio.play()
		if Globals.head:
			Globals.head.is_dead = is_dead

@export var can_move: bool = true

func _ready() -> void:
	Globals.player = self
	vignette.show()
	floor_snap_length = 6

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
	if can_move: 
		get_input()
	else:
		velocity.x = 0
	gravity()
	select_animation()
	move_and_slide()

func get_input():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	if velocity.x:
		body.scale.x = sign(velocity.x)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= JUMP_HEIGHT
		audio_stream_player.play()

func select_animation():
	if is_on_floor():
		if velocity.x:
			play_animation("run")
		else:
			play_animation("idle")
	else:
		play_animation("fly")

func play_animation(animation_name):
	if animation_player.current_animation != animation_name:
		animation_player.stop()
	animation_player.play(animation_name)

func gravity():
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, GRAVITY, GRAVITY_ACCEL)

func _on_hurt_box_area_entered(_area: Area2D) -> void:
	is_dead = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "dead":
		dead_signal.emit()

func disable(value: bool = true):
	if value:
		process_mode = Node.PROCESS_MODE_DISABLED
		camera_2d.enabled = false
	else:
		process_mode = Node.PROCESS_MODE_INHERIT
		camera_2d.enabled = true
