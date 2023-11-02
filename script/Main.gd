extends Node

var setting1 := false;
var setting2 := true;
var setting3 := false;
var setting4 := false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey:
		if Input.is_action_pressed("Quit"):
			get_tree().quit()
		if Input.is_action_just_pressed("testSetting1"):
			setting1 = true;
			setting2 = false;
			setting3 = false;
			setting4 = false;
		if Input.is_action_just_pressed("testSetting2"):
			setting1 = false;
			setting2 = true;
			setting3 = false;
			setting4 = false;
		if Input.is_action_just_pressed("testSetting3"):
			setting1 = false;
			setting2 = false;
			setting3 = true;
			setting4 = false;
		if Input.is_action_just_pressed("testSetting4"):
			setting1 = false;
			setting2 = false;
			setting3 = false;
			setting4 = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
