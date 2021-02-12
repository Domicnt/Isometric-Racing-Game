extends Node

var current_scene = null;

var config = ConfigFile.new();
var err = config.load("user://settings.cfg");

func get_resolution ():
	return config.get_value("display", "resolution");
func set_resolution (res):
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
	config.save("user://settings.cfg");

func get_display_mode():
	return config.get_value("display", "mode");
func set_display_mode(mode):
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
	config.save("user://settings.cfg");

func get_volume():
	return AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"));
func set_volume(volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume);
	config.set_value("audio", "volume", volume);
	config.save("user://settings.cfg");

func get_keybind(event, key):
	return config.get_value("controls", event, key);
func set_keybind(event, key):
	if !InputMap.get_action_list(event).empty():
		InputMap.action_erase_event(event, InputMap.get_action_list(event)[0]);
	InputMap.action_add_event(event, key);
	config.set_value("controls", event, key);
	config.save("user://settings.cfg");

var money = 0;
var stage = 1;
var upgrade = 1;
var stage_times = [0];

var save = File.new();
func save_file(file):
	save.set_value("money", money);
	save.set_value("stage", stage);
	save.set_value("upgrade", upgrade);
	save.set_value("stage_times", stage_times);
	save.save("user://" + file + ".cfg");
func load_file(file):
	var err = save.load("user://" + file + ".cfg");
	if err != OK:
		save.set_value("money", money);
		save.set_value("stage", stage);
		save.set_value("upgrade", upgrade);
		save.set_value("stage_times", stage_times);
	else:
		money = save.get_value("money");
		stage = save.get_value("stage");
		upgrade = save.get_value("upgrade");
		stage_times = save.get_value("stage_times");

func get_stage_time(stage):
	return stage_times[stage - 1];
func set_stage_time(stage, time):
	while stage_times.size() < stage:
		stage_times.push_back(null);
	stage_times[stage - 1] = time;

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
	set_resolution(config.get_value("display", "resolution"));
	#display mode
	set_display_mode(config.get_value("display", "mode"));
	#volume
	set_volume(config.get_value("audio", "volume"));
	#key bindings
	set_keybind("forwards", config.get_value("controls", "forwards"));
	set_keybind("backwards", config.get_value("controls", "backwards"));
	set_keybind("left", config.get_value("controls", "left"));
	set_keybind("right", config.get_value("controls", "right"));
	set_keybind("brake", config.get_value("controls", "brake"));

	config.save("user://settings.cfg");

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
