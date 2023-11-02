extends Node

# Singleton instance
var gameNode : Node;

@onready var bulletScene := preload("res://scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func createBulletHoleDecal(position: Vector3, collisionNormal: Vector3, trajectory: Vector3) -> void: 
	gameNode.createBulletHoldeDecal(position, collisionNormal, trajectory);

