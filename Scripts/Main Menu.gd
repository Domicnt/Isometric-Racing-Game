extends MarginContainer

onready var save_menu = get_node("HBoxContainer/VBoxContainer/New Game/PopupMenu");
onready var options_menu = get_node("HBoxContainer/VBoxContainer/Options/PopupMenu");
onready var credits = get_node("HBoxContainer/VBoxContainer/Credits/Sprite");

func _on_Continue_pressed():
	Global.goto_scene("res://Scenes/Level Select.tscn");

func _on_New_Game_pressed():
	save_menu.popup_centered();

func _on_Options_pressed():
	options_menu.popup_centered();

func _on_Credits_pressed():
	credits.visible = true;

func _on_Exit_pressed():
	get_tree().quit();
