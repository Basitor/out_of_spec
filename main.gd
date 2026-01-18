extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var first_scene: PackedScene

var level_instance: Level
var next_scene: PackedScene


func _ready() -> void:
	load_level(first_scene)

func load_level(level: PackedScene):
	if level:
		level_instance = level.instantiate()
		get_tree().current_scene.call_deferred("add_child", level_instance)
		next_scene = level_instance.next_level
		level_instance.launch_next_level.connect(load_next_level)
		pause_next_scene()
		animation_player.play("next_level")

func load_next_level():
	level_instance.queue_free()
	load_level(next_scene)
	
func pause_next_scene(value: bool = true):
	level_instance.set_process(value)

func _on_button_pressed() -> void:
	audio_stream_player.playing = not audio_stream_player.playing
