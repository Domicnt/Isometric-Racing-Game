extends Popup

func _ready():
	self.popup_exclusive = true;
	
	var time = yield(get_node("../../."), "finish");
	get_node("Control/MarginContainer/VBoxContainer/MarginContainer/Time").bbcode_text = "[center]Time: " + str(time) + " seconds[/center]";	

func _on_Continue_pressed():
	Global.goto_scene("res://Scenes/Main Menu 2.tscn");
