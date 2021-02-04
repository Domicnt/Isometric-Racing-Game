extends MarginContainer

onready var levels_node = get_node("TabContainer/Events/ScrollContainer/Levels");
var levels = Array();

func _ready():
	for i in levels_node.get_children():
		levels.push_back(i);
	for i in levels.size():
		get_node(str(levels[i].get_path()) + "/Panel/VBoxContainer/TextureButton").connect("pressed", self, "_on_level_select", [i]);
		get_node(str(levels[i].get_path()) + "/Panel/CenterContainer/Sprite").visible = i > Global.level;

func _on_level_select(i):
	if (i <= Global.level):
		Global.goto_scene("res://Scenes/Levels/" + str(i+1) + ".tscn");
