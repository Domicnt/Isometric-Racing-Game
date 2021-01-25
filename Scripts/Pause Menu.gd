extends Popup

func _ready():
	self.popup_exclusive = true;

func _input(event):
	if event.is_action_pressed("menu_toggle"):
		if self.visible:
			self.hide();
		else:
			self.popup();
		get_tree().paused = !get_tree().paused;


func _on_Resume_pressed():
	self.hide();
	get_tree().paused = false;


func _on_Restart_pressed():
	self.hide();
	get_tree().paused = false;
	Global.goto_scene(get_tree().current_scene.filename);


func _on_Exit_pressed():
	Global.goto_scene("res://Scenes/Main Menu 2.tscn");
