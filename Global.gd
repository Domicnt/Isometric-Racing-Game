extends Node

var current_scene = null;

var config = ConfigFile.new();
var err = config.load("res://settings.cfg");

func change_resolution (res):
	match res:
		0:
			#1920x1080
			OS.set_window_size(Vector2(1920, 1080));
		1:
			#1280x720
			OS.set_window_size(Vector2(1280, 720));
		2:
			#852x480
			OS.set_window_size(Vector2(852, 480));
	config.set_value("display", "resolution", res);
	config.save("res://settings.cfg");

func change_display_mode(mode):
	match mode:
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
	config.set_value("display", "mode", mode);
	config.save("res://settings.cfg");

func change_volume(volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume);
	config.set_value("audio", "volume", volume);
	config.save("res://settings.cfg");

func change_keybind(event, key):
	if !InputMap.get_action_list(event).empty():
		InputMap.action_erase_event(event, InputMap.get_action_list(event)[0]);
	InputMap.action_add_event(event, key);
	config.set_value("controls", event, key);
	config.save("res://settings.cfg");

func _ready():
	var root = get_tree().get_root();
	current_scene = root.get_child(root.get_child_count() - 1);
	
	if err != OK:
		config.set_value("display", "resolution", 0);
		config.set_value("display", "mode", 1);
		config.set_value("audio", "volume", 100);
		var w = InputEventKey.new();
		w.set_scancode(KEY_W);
		config.set_value("controls", "forwards", w);
		var s = InputEventKey.new();
		s.set_scancode(KEY_S);
		config.set_value("controls", "backwards", s);
		var a = InputEventKey.new();
		a.set_scancode(KEY_A);
		config.set_value("controls", "left", a);
		var d = InputEventKey.new();
		d.set_scancode(KEY_D);
		config.set_value("controls", "right", d);
		var space = InputEventKey.new();
		space.set_scancode(KEY_SPACE);
		config.set_value("controls", "brake", space);
	
	#resolution
	change_resolution(config.get_value("display", "resolution"));
	#display mode
	change_display_mode(config.get_value("display", "mode"));
	#key bindings
	change_keybind("forwards", config.get_value("controls", "forwards"));
	change_keybind("backwards", config.get_value("controls", "backwards"));
	change_keybind("left", config.get_value("controls", "left"));
	change_keybind("right", config.get_value("controls", "right"));
	change_keybind("brake", config.get_value("controls", "brake"));

	config.save("res://settings.cfg");

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path);

func _deferred_goto_scene(path):
	current_scene.free();
	var s = ResourceLoader.load(path);
	current_scene = s.instance();
	get_tree().get_root().add_child(current_scene);
	get_tree().set_current_scene(current_scene);

signal pressed;

func _input(event):
	if event is InputEventKey:
		emit_signal("pressed", event);

