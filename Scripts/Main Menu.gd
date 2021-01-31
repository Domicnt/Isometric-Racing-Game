extends MarginContainer

onready var save_menu = get_node("CenterContainer/PopupMenu");
onready var credits = get_node("HBoxContainer/VBoxContainer/Credits/Sprite");

func _on_Continue_pressed():
	#Global.goto_scene("res://Scenes/Main Menu 2.tscn");
	pass;

func _on_New_Game_pressed():
	save_menu.popup_centered();

func _on_Options_pressed():
	Global.goto_scene("res://Scenes/Options Menu.tscn");

func _on_Credits_pressed():
	credits.visible = true;

func _on_Exit_pressed():
	get_tree().quit();


func _on_File_1_pressed():
	Global.goto_scene("res://Scenes/Main Menu 2.tscn");

func _on_File_2_pressed():
	Global.goto_scene("res://Scenes/Main Menu 2.tscn");

func _on_File_3_pressed():
	Global.goto_scene("res://Scenes/Main Menu 2.tscn");

func _on_File_4_pressed():
	Global.goto_scene("res://Scenes/Main Menu 2.tscn");

func _on_File_5_pressed():
	Global.goto_scene("res://Scenes/Main Menu 2.tscn");
