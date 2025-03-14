extends Node2D

var dungeon = {}
const ROOMS = {
	"B": preload("res://Assets/B.png"),
	"BL": preload("res://Assets/BL.png"),
	"BLR": preload("res://Assets/BLR.png"),
	"BR": preload("res://Assets/BR.png"),
	"L": preload("res://Assets/L.png"),
	"LR": preload("res://Assets/LR.png"),
	"R": preload("res://Assets/R.png"),
	"T": preload("res://Assets/T.png"),
	"TB": preload("res://Assets/TB.png"),
	"TBL": preload("res://Assets/TBL.png"),
	"TBLR": preload("res://Assets/TBLR.png"),
	"TBR": preload("res://Assets/TBR.png"),
	"TL": preload("res://Assets/TL.png"),
	"TLR": preload("res://Assets/TLR.png"),
	"TR": preload("res://Assets/TR.png")
}

@onready var map_node = $MapNode

func _ready():
	dungeon = DungeonGeneration.generate(randi_range(-100, 100))
	load_map()

func load_map():
	for i in range(0, map_node.get_child_count()):
		map_node.get_child(i).queue_free()
		
	for i in dungeon.keys():
		var room_name = check_connection_directions(dungeon.get(i).connected_rooms)
		var temp = Sprite2D.new()
		for x in ROOMS.keys():
			if room_name == x:
				temp.texture = ROOMS.get(x)
		map_node.add_child(temp)
		temp.z_index = 1
		temp.position = i * 10
		
		if dungeon.get(i).starting_room:
			const START_MARKER = preload("res://start_marker.tscn")
			var new_start_marker = START_MARKER.instantiate()
			new_start_marker.z_index = 1
			new_start_marker.global_position = temp.position
			map_node.add_child(new_start_marker)
		elif dungeon.get(i).ending_room:
			const END_MARKER = preload("res://end_marker.tscn")
			var new_end_marker = END_MARKER.instantiate()
			new_end_marker.z_index = 1
			new_end_marker.global_position = temp.position
			map_node.add_child(new_end_marker)

func check_connection_directions(connected_rooms):
	var room_name = ""
	if connected_rooms.get(Vector2(0, -1)) != null:
		room_name += "T"
	if connected_rooms.get(Vector2(0, 1)) != null:
		room_name += "B"
	if connected_rooms.get(Vector2(-1, 0)) != null:
		room_name += "L"
	if connected_rooms.get(Vector2(1, 0)) != null:
		room_name += "R"
	
	return room_name

func _on_button_pressed() -> void:
	randomize()
	dungeon = DungeonGeneration.generate(randi_range(-1000, 1000))
	load_map()
