extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var gun: Sprite2D = $Gun
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# effects
@onready var effects: Node2D = $Effects
@onready var markers: Node2D = $Gun/Markers
@onready var tracer: Line2D = $Effects/Tracer
@onready var flash: Node2D = $Effects/Flash
@onready var color_rect: ColorRect = $ColorRect
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer

# timers
@onready var post_timer: Timer = $PostTimer
@onready var shot_timer: Timer = $ShotTimer
@onready var effects_timer: Timer = $Effects/EffectsTimer
@onready var aim_delay_timer: Timer = $AimDelayTimer

# export vars
@export var max_shot_timeout = 0.5
@export var min_shot_timeout = 0.15
@export var aim_delay := 0.2
@export var gun_distance:= 170.0

# global vars
var shot_target: Vector2
var player: CharacterBody2D
var shot_timeout = max_shot_timeout

func _ready() -> void:
	player = Globals.player

func _spawn_hit(hit_point: Vector2):
	gpu_particles_2d.global_position = hit_point
	gpu_particles_2d.restart()

func _on_scan_timer_timeout() -> void:
	var player_position: Vector2 = player.global_position + Vector2(0, -10)
	ray_cast_2d.target_position = ray_cast_2d.to_local(player_position) * 2
	ray_cast_2d.force_raycast_update()

	if not post_timer.is_stopped():
		shot_target = ray_cast_2d.get_collision_point()
		gun.look_at(shot_target)
		gun.rotation -= PI / 2
		animation_player.play("rotate")

	if ray_cast_2d.get_collider() == player:
		var distance := gun.global_position.distance_to(ray_cast_2d.get_collision_point())
		if distance > gun_distance:
			return

		color_rect.show()
		post_timer.start()

		if shot_timer.is_stopped():
			shot_timer.start(shot_timeout)

func _on_post_timer_timeout() -> void:
	animation_player.stop()
	shot_target = Vector2.ZERO
	shot_timeout = max_shot_timeout
	color_rect.hide()

func _on_shot_timer_timeout() -> void:
	if shot_target != Vector2.ZERO:
		audio_stream_player.play()
		ray_cast_2d.force_raycast_update()
		var target: Vector2 = ray_cast_2d.get_collision_point()
		var marker := markers.get_child(randi_range(0, markers.get_child_count() - 1))
		effects.global_position = marker.global_position
		effects.show()
		tracer.clear_points()
		tracer.add_point(Vector2.ZERO)
		tracer.add_point(tracer.to_local(target))
		flash.rotation = randf() * TAU
		effects_timer.start()
		_spawn_hit(target)

		shot_timeout -= 0.05
		shot_timeout = max(min_shot_timeout, shot_timeout)
		shot_timer.start(shot_timeout)
		
		if ray_cast_2d.get_collider() == player:
			player.is_dead = true

func _on_effects_timer_timeout() -> void:
	effects.hide()
