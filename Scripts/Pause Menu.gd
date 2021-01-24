extends Popup

func _ready():
	self.popup_exclusive = true;

func _input(event):
	if event.is_action_pressed("menu_toggle"):
		print(self.visible);
		print(self.rect_position);
		if self.visible:
			self.hide();
		else:
			self.popup();
		get_tree().paused = !get_tree().paused;
