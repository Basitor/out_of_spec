extends Node2D
@export var tile_layer: TileMapLayer
@export var HEAD_FOLLOW_SPEED: float = 600.0
@export var HEAD_SNAP_DIST: float = 5.0

@export var enable_darkness: bool = false
@export var enable_leave_head: bool = false
@export var head_on_body: bool = true

@onready var player_head: Sprite2D = $PlayerHead
@onready var light_area: Area2D = $LightArea
@onready var light_collision: CollisionPolygon2D = $LightArea/LightCollision
@onready var dark_collision: CollisionPolygon2D = $LightArea/DarkCollision
@onready var point_light_2d: PointLight2D = $LightArea/PointLight2D
@onready var sprite_material: Material = $PlayerHead.material
@onready var click_sound: AudioStreamPlayer = $ClickSound


var player_marker: Marker2D
var current_collision: CollisionPolygon2D 

var freezed: bool = false
var is_dead: bool = false
var initializing: bool = true

@onready var light_type: bool:
	set(value):
		if value != light_type and not initializing:
			click_sound.play()

		light_type = value
		point_light_2d.blend_mode = int( not value ) as Light2D.BlendMode
		sprite_material.set_shader_parameter("reverse", not value)
		if value:
			dark_collision.show()
			current_collision = dark_collision
			light_collision.hide()
		else:
			light_collision.show()
			current_collision = light_collision
			dark_collision.hide()

func _ready() -> void:
	Globals.head = self
	light_type = true
	initializing = false

func _physics_process(delta: float) -> void:
	if not is_dead:
		get_input()
		if not freezed: 
			rotate_head()
	if head_on_body: move_head(delta)
	apply_light_to_tiles()

func get_input():
	if enable_leave_head:
		if Input.is_action_just_pressed("action"): 
			head_on_body = not head_on_body

		freezed = Input.is_action_pressed("freeze")

	if enable_darkness:
		if Input.is_action_just_pressed("light_type"):
			light_type = not light_type

func rotate_head():
	look_at(get_global_mouse_position())
	player_head.flip_v = get_global_mouse_position().x < global_position.x

func move_head(delta: float):
	if player_marker:
		var target := player_marker.global_position
		global_position = global_position.move_toward(target, HEAD_FOLLOW_SPEED * delta)
		if global_position.distance_to(target) <= HEAD_SNAP_DIST:
			global_position = target

func apply_light_to_tiles():
	if tile_layer == null:
		return

	var poly_global := PackedVector2Array()
	var xf := current_collision.global_transform
	for p in current_collision.polygon:
		poly_global.append(xf * p)

	tile_layer.apply_light_polygon(poly_global, light_type)

func disable(value: bool = true):
	if value:
		sprite_material.set_shader_parameter("disable", value)
		process_mode = Node.PROCESS_MODE_DISABLED
		light_area.hide()
	else:
		sprite_material.set_shader_parameter("disable", value)
		process_mode = Node.PROCESS_MODE_INHERIT
		light_area.show()
