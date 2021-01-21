extends MarginContainer

func _ready():
	var resolution = get_node("HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Resolution");
	resolution.add_item("1920x1080");
	resolution.add_item("1280x720");
	resolution.add_item("852x480");
	
	var displayMode = get_node("HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/DisplayMode")
	displayMode.add_item("Windowed");
	displayMode.add_item("Borderless");
	displayMode.add_item("Fullscreen");
	pass;

# Drop down menus
func _on_Resolution_item_selected(index):
	match index:
		0:
			#1920x1080
			OS.set_window_size(Vector2(1920, 1080));
		1:
			#1280x720
			OS.set_window_size(Vector2(1280, 720));
		2:
			#852x480
			OS.set_window_size(Vector2(852, 480));

func _on_DisplayMode_item_selected(index):
	match index:
		0: 
			#windowed
			OS.window_fullscreen = false;
			OS.window_borderless = false;
			OS.window_maximized = false;
		1:
			#borderless windowed
			OS.window_fullscreen = false;
			OS.window_borderless = true;
			OS.window_maximized = true;
		2:
			#fullscreen
			OS.window_fullscreen = true;
			OS.window_borderless = false;
			OS.window_maximized = false;


# Volume slider
func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _record_and_change(node, event):
	node.bbcode_text = "[center]Record New[/center]";
	if !InputMap.get_action_list(event).empty():
		InputMap.action_erase_event(event, InputMap.get_action_list(event)[0]);
		
	var key = yield(Global, "pressed");
	InputMap.action_add_event(event, key);
	node.bbcode_text = "[center]" + OS.get_scancode_string(key.scancode) + "[/center]";

# Keybinds
func _on_Forwards_pressed():
	_record_and_change(get_node("HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer/Forwards/MarginContainer/RichTextLabel"), "forwards");

func _on_Backwards_pressed():
	_record_and_change(get_node("HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer2/Backwards/MarginContainer/RichTextLabel"), "backwards");

func _on_Left_pressed():
	_record_and_change(get_node("HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer3/Left/MarginContainer/RichTextLabel"), "left");

func _on_Right_pressed():
	_record_and_change(get_node("HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer4/Right/MarginContainer/RichTextLabel"), "right");

func _on_Brake_pressed():
	_record_and_change(get_node("HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer5/Brake/MarginContainer/RichTextLabel"), "brake");


func _on_Back_pressed():
	Global.goto_scene("res://Scenes/Main Menu.tscn");
