extends Node
class_name Game

const ACHIEVEMENT = preload("res://Achievement/achievement.tscn")

var player: Node2D
var head: Node2D

var past_achievements: Array

func earh_achievement(text):
	if text in past_achievements: return
	var new_achievement = ACHIEVEMENT.instantiate()
	new_achievement.text = text
	get_tree().current_scene.call_deferred("add_child", new_achievement)
	past_achievements.append(text)
