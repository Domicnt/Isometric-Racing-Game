extends Popup

func _ready():
	self.popup_exclusive = true;



func _on_Continue_pressed():
	Global.goto_scene("res://Scenes/Main Menu 2.tscn");
