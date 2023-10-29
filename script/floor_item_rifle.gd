extends Node3D
@onready var animation_player = $AnimationPlayer
@onready var mesh_instance_3d = $MeshInstance3D
@onready var omni_light_3d = $OmniLight3D
@onready var timer = $Timer
@onready var audio_stream_player_3d = $AudioStreamPlayer3D


var isRefreshing := false;
var currentRespawnTime := 0;
const respawnTime := 10;

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("spin");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if isRefreshing: 
		mesh_instance_3d.visible = false;
		omni_light_3d.visible = false;
	else:
		mesh_instance_3d.visible = true;
		omni_light_3d.visible = true;
	
	#print(timer.get_time_left())
	
	if timer.get_time_left() <= 0.3:
		isRefreshing = false;
		timer.stop();

func _on_pick_up_area_body_entered(body):
	print(body);
	if timer.get_time_left() <= 0.0: 
		isRefreshing = true;
		timer.one_shot = true;
		timer.wait_time = respawnTime;
		timer.start();
		audio_stream_player_3d.play();
