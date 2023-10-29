extends Node3D
@onready var animation_player = $AnimationPlayer
@onready var area_3d = $Area3D
@onready var mesh_instance_3d = $MeshInstance3D
@onready var omni_light_3d = $OmniLight3D
@onready var timer = $Timer

var isRefreshing := false;
var currentRespawnTime := 0;
const respawnTime := 25;

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("spin");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isRefreshing: 
		mesh_instance_3d.visible = false;
		omni_light_3d.visible = false;
		currentRespawnTime -= 1;
	else:
		mesh_instance_3d.visible = true;
		omni_light_3d.visible = true;
	
	if timer.get_time_left() == 0:
		isRefreshing = false;
		timer.stop();
	

func _on_area_3d_area_entered(area):
	isRefreshing = true;
	currentRespawnTime = respawnTime;
	
	if timer.get_time_left() == 0: 
		timer.one_shot = true;
		timer.wait_time = respawnTime;
		timer.start();
