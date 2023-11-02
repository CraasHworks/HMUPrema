extends Node3D

@onready var edge_check_down = $EdgeCheckDown
@onready var edge_check_left = $EdgeCheckLeft
@onready var edge_check_right = $EdgeCheckRight
@onready var edge_check_up = $EdgeCheckUp

func getIsCloseToEdge(): 
	var emptyV = Vector3.ZERO
	edge_check_down.force_raycast_update();
	edge_check_left.force_raycast_update();
	edge_check_right.force_raycast_update();
	edge_check_up.force_raycast_update();
	if edge_check_down.get_collision_point() == emptyV || edge_check_left.get_collision_point() == emptyV || edge_check_right.get_collision_point() == emptyV || edge_check_up.get_collision_point() == emptyV :
		return true; 
	else :
		return false;  

func _on_timer_timeout():
	queue_free();
