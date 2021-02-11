extends Area2D

onready var popup_node = get_node("CanvasLayer/Post-Race Menu");
onready var car = get_node("../RigidBody2D");

var time_start = 0
signal finish;

var checkpoints = Array();
var checkpoints_passed = Array();

func _ready():
	for i in self.get_children():
		if i is Area2D:
			checkpoints.push_back(i);
			checkpoints_passed.push_back(false);
	for i in checkpoints.size():
		checkpoints[i].connect("area_entered", self, "_on_checkpoint_enter", [i]);
	time_start = OS.get_unix_time();

func _on_checkpoint_enter(_area, i):
	checkpoints_passed[i] = true;

#if anything goes into the start/finish area
func _on_Area2D_area_entered(_area):
	for i in checkpoints_passed:
		if i == false:
			return;
		else:
			i = false;
	emit_signal("finish", OS.get_unix_time() - time_start);
	popup_node.popup();
	get_tree().paused = true;
