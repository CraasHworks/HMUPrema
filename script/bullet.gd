extends Node3D

#imports
@onready var ray_cast_3d = $collisionChecker

signal bulletHitType1(pos);

#Bulletvarsa
var velocity := Vector3.ZERO;
var isDestroyed = false;
@export var speed :=  50;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isDestroyed: 
		self.queue_free();
		return;
	else: 
		self.transform.origin -= velocity * delta * speed;
	
		ray_cast_3d.force_raycast_update();
		if ray_cast_3d.is_colliding():
			var collider = ray_cast_3d.get_collider()
			# var colliderMaskId = ray_cast_3d.get_collision_mask_value(1)
			# print("Bullet hit %s" % [collider.name])
			
			ProjectileHandler.createBulletHoleDecal(ray_cast_3d.get_collision_point(), ray_cast_3d.get_collision_normal(), self.rotation);
			#ProjectileHandler.createBulletHoleDecal(ray_cast_3d.get_collision_point(), self.rotation);
			# Move the bullet back to the position of the collision
			self.global_transform.origin = ray_cast_3d.get_collision_point();
			isDestroyed = true;

func _on_timer_timeout():
	isDestroyed = true;
