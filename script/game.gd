extends Node3D

@onready var projectiles = $Projectiles;
@onready var decals = $Decals
@onready var bulletScene := preload("res://scenes/bullet.tscn");
@onready var BulletHole := preload("res://scenes/bullet_hole.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	ProjectileHandler.gameNode = self;
	pass 

func _input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("Quit"):
			get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func createBulletHoldeDecal(pos, collision_normal, tradjectory):
	var bulletHole = BulletHole.instantiate() as Node3D;
	decals.add_child(bulletHole);
	var x_axis = collision_normal.cross(Vector3(0, 0, 1)).normalized()
	var y_axis = collision_normal.cross(x_axis).normalized()
	var z_axis = collision_normal.normalized()

	var rotation_matrix = Basis(x_axis, y_axis, z_axis)
	bulletHole.position = pos;
	bulletHole.transform.basis = rotation_matrix;
	bulletHole.scale = Vector3(0.25, 0.25, 0.15);
	print(bulletHole.getIsCloseToEdge())
	if bulletHole.getIsCloseToEdge(): 
		bulletHole.rotation = tradjectory;

func _on_player_shooting(pos, direction, protorato):
	var bullet = bulletScene.instantiate() as Node3D
	bullet.position = pos;
	bullet.rotation = protorato
	bullet.velocity = direction;
	projectiles.add_child(bullet);
