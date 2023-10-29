extends Node3D

@onready var projectiles = $Projectiles;
var bulletScene := preload("res://bullet.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if Input.is_action_pressed("Quit"):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass




func _on_player_shooting(pos, direction, protorato):
	var bullet = bulletScene.instantiate() as Node3D
	bullet.position = pos;
	#bullet.rotation = pos
	bullet.velocity = direction;
	projectiles.add_child(bullet);
