extends Area2D

onready var popup_node = get_node("PopupPanel");
onready var car = get_node("../RigidBody2D");

var checkpoints = Array();
var checkpoints_passed = Array();

func _ready():
	for i in self.get_children():
		if i is Area2D:
			checkpoints.push_back(i);
			checkpoints_passed.push_back(false);
	for i in checkpoints.size():
		checkpoints[i].connect("area_entered", self, "_on_checkpoint_enter", [i]);

func _on_checkpoint_enter(_area, i):
	checkpoints_passed[i] = true;

#if anything goes into the start/finish area
func _on_Area2D_area_entered(_area):
	for i in checkpoints_passed:
		if i == false:
			return;
		else:
			i = false;
	print("you win");
	popup_node.popup_centered();
	popup_node.set_position(car.position);
	get_tree().paused = true
