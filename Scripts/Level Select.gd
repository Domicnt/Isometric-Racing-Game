extends Node2D

var levels = Array();

func _ready():
	for i in self.get_children():
		if i is Area2D:
			levels.push_back(i);
	for i in levels:
		i.connect("area_entered", self, "_on_level_enter", [i]);
		#_on_level_enter(i);

func _on_level_enter(_area, i):
	Global.goto_scene("res://Scenes/Levels/" + i.get_name() + ".tscn");
	print(i);
