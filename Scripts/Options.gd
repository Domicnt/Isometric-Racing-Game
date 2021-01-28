extends MarginContainer

onready var forwards = get_node("HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer/Forwards/MarginContainer/RichTextLabel");
onready var backwards = get_node("HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer2/Backwards/MarginContainer/RichTextLabel")
onready var left = get_node("HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer3/Left/MarginContainer/RichTextLabel");
onready var right = get_node("HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer4/Right/MarginContainer/RichTextLabel");
onready var brake = get_node("HBoxContainer/MarginContainer3/VBoxContainer/HBoxContainer5/Brake/MarginContainer/RichTextLabel");

func set_bindings_text():
	forwards.bbcode_text = "[center]" + InputMap.get_action_list("forwards")[0].as_text() + "[/center]";
	backwards.bbcode_text = "[center]" + InputMap.get_action_list("backwards")[0].as_text() + "[/center]";
	left.bbcode_text = "[center]" + InputMap.get_action_list("left")[0].as_text() + "[/center]";
	right.bbcode_text = "[center]" + InputMap.get_action_list("right")[0].as_text() + "[/center]";
	brake.bbcode_text = "[center]" + InputMap.get_action_list("brake")[0].as_text() + "[/center]";

func _ready():
	var resolution = get_node("HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Resolution");
	resolution.add_item("1920x1080");
	resolution.add_item("1280x720");
	resolution.add_item("852x480");
	
	var displayMode = get_node("HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/DisplayMode")
	displayMode.add_item("Windowed");
	displayMode.add_item("Borderless");
	displayMode.add_item("Fullscreen");
	
	set_bindings_text();

# Drop down menus
func _on_Resolution_item_selected(index):
	Global.change_resolution(index);

func _on_DisplayMode_item_selected(index):
	Global.change_display_mode(index);


# Volume slider
func _on_HSlider_value_changed(value):
	Global.change_volume(value);


func _record_and_change(node, event):
	node.bbcode_text = "[center]Record New[/center]";
	
	var key = yield(Global, "pressed");
	Global.change_keybind(event, key);
	
	set_bindings_text();

# Keybinds
func _on_Forwards_pressed():
	_record_and_change(forwards, "forwards");

func _on_Backwards_pressed():
	_record_and_change(backwards, "backwards");

func _on_Left_pressed():
	_record_and_change(left, "left");

func _on_Right_pressed():
	_record_and_change(right, "right");

func _on_Brake_pressed():
	_record_and_change(brake, "brake");


func _on_Back_pressed():
	Global.goto_scene("res://Scenes/Main Menu.tscn");
