extends Area2D

func _on_Area2D_area_entered(area):
	print(area.get_name());
	Global.goto_scene("res://Scenes/Levels/" + area.get_name() + ".tscn");

func _on_Area2D_area_exited(area):
	print(area.get_name());
