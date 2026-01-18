extends Node2D

class_name Level

@onready var head: Node2D = $Head
@onready var player: CharacterBody2D = $Player
@onready var player_marker: Marker2D = $Player/HeadMarker
@onready var tile_map: TileMapLayer = $World/TileMap
@onready var checkpoints: Node2D = $Checkpoints
@onready var bg: Sprite2D = $BG
@onready var gates: Area2D = $Gates


@export var next_level: PackedScene
@export var tutorial: bool = false


signal launch_next_level

var current_spawn: Vector2


func _ready() -> void:
	bg.show()
	gates.show()
	head.global_position = player_marker.global_position
	head.tile_layer = tile_map
	head.player_marker = player_marker
	tile_map.player = player
	current_spawn = player.global_position
	player.connect("dead_signal", level_failed)
	for checkpoint: Area2D in checkpoints.get_children():
		checkpoint.connect("player_entered", set_spawn)
	
	if tutorial:
		disable_player()

func level_failed():
	player.global_position = current_spawn
	head.global_position = current_spawn - Vector2(0, -5)
	player.is_dead = false

func disable_player(value: bool = true):
	player.disable(value)
	head.disable(value)

func set_spawn(checkpoint_spawn: Vector2):
	current_spawn = checkpoint_spawn

func _on_gates_body_entered(_body: Node2D) -> void:
	print(_body, " entered gates")
	launch_next_level.emit()
