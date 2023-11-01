extends Node

# Singleton instance
var gameNode : Node

@onready var bulletScene := preload("res://scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func createBulletHoleDecal(pos: Vector3, velocity: Vector3) -> void: 
	gameNode.createBulletHoldeDecal(pos, velocity);

