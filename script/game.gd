extends Node3D

@onready var projectiles = $Projectiles;
@onready var decals = $Decals

@onready var bulletScene := preload("res://scenes/bullet.tscn");
@onready var BulletHole := preload("res://scenes/bullet_hole.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	ProjectileHandler.gameNode = self;
	pass 

func _input(_event):
	if Input.is_action_pressed("Quit"):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func createBulletHoldeDecal(pos, collision_normal):
	var bulletHole = BulletHole.instantiate() as Node3D;
	print(collision_normal);
	if collision_normal.x == -1 || collision_normal.x == 1:
		bulletHole.rotate_y(deg_to_rad(90));
	elif collision_normal.y == -1 || collision_normal.y == 1: 
		bulletHole.rotate_x(deg_to_rad(90));
	
	bulletHole.position = pos;
	bulletHole.rotation = collision_normal;
#    else:
#		var x_axis = collision_normal.cross(Vector3(0, 0, 1)).normalized()
#		var y_axis = collision_normal.cross(x_axis).normalized()
#		var z_axis = collision_normal.normalized()
#
#		var rotation_matrix = Basis(x_axis, y_axis, z_axis)
#		bulletHole.position = pos;
#		bulletHole.transform.basis = rotation_matrix;
	
	
#	bulletHole.transform = Transform3D(rotation_matrix, pos);
#	print("Target normal is: x: ", direction.x, ", y: ", direction.y, ", z: ", direction.z )
#	if direction.z == 1 || direction.z == -1:
#		print("hey")
#		return
#	else:
#		print("hos")
#		bulletHole.rotation = Vector3(0, 0, 1);
#	bulletHole.rotation = direction;
	
	decals.add_child(bulletHole);

func _on_player_shooting(pos, direction, protorato):
	var bullet = bulletScene.instantiate() as Node3D
	bullet.position = pos;
	bullet.rotation = protorato
	bullet.velocity = direction;
	projectiles.add_child(bullet);
