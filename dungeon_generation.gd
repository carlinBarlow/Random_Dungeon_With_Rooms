extends Node

var ROOM = preload("res://room.tscn")

var min_number_of_rooms = 10
var max_number_of_rooms = 20

var generation_chance = 20

func generate(room_seed):
	seed(room_seed)
	var dungeon = {}
	var size = randi_range(min_number_of_rooms, max_number_of_rooms)
	dungeon[Vector2(0, 0)] = ROOM.instantiate()
	dungeon[Vector2(0, 0)].starting_room = true
	size -= 1
	
	while size > 0:
		for i in dungeon.keys():
			if randi_range(0, 100) < generation_chance and size > 0:
				var direction = randi_range(0, 4)
				if direction == 0:
					var new_room_position = i + Vector2(1, 0)
					if !dungeon.has(new_room_position):
						dungeon[new_room_position] = ROOM.instantiate()
						size -= 1
					
					if dungeon.get(i).connected_rooms.get(Vector2(1, 0)) == null:
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(1, 0))
				elif direction == 1:
					var new_room_position = i + Vector2(-1, 0)
					if !dungeon.has(new_room_position):
						dungeon[new_room_position] = ROOM.instantiate()
						size -= 1
					
					if dungeon.get(i).connected_rooms.get(Vector2(-1, 0)) == null:
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(-1, 0))
				elif direction == 2:
					var new_room_position = i + Vector2(0, 1)
					if !dungeon.has(new_room_position):
						dungeon[new_room_position] = ROOM.instantiate()
						size -= 1
					
					if dungeon.get(i).connected_rooms.get(Vector2(0, 1)) == null:
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(0, 1))
				elif direction == 3:
					var new_room_position = i + Vector2(0, -1)
					if !dungeon.has(new_room_position):
						dungeon[new_room_position] = ROOM.instantiate()
						size -= 1
					
					if dungeon.get(i).connected_rooms.get(Vector2(0, -1)) == null:
						connect_rooms(dungeon.get(i), dungeon.get(new_room_position), Vector2(0, -1))
	
	var end_room_candidates = []
	for i in dungeon.keys():
		if dungeon.get(i).number_of_connections == 1 and !dungeon.get(i).starting_room:
			end_room_candidates.append(i)
	
	dungeon[end_room_candidates[randi_range(0, end_room_candidates.size() - 1)]].ending_room = true
	
	while !is_interesting(dungeon):
		for i in dungeon.keys():
			dungeon.get(i).queue_free()
		dungeon = generate(room_seed * randi_range(-100, 100) + randi_range(-100, 100))
	
	return dungeon

func connect_rooms(room1, room2, direction):
	room1.connected_rooms[direction] = room2
	room2.connected_rooms[-direction] = room1
	room1.number_of_connections += 1
	room2.number_of_connections += 1

func is_interesting(dungeon):
	var rooms_with_three_connections = 0
	for i in dungeon.keys():
		if dungeon.get(i).number_of_connections >= 3:
			rooms_with_three_connections += 1
	
	var next_to_start = false
	for i in dungeon.get(Vector2(0, 0)).connected_rooms.keys():
		if dungeon.get(Vector2(0, 0)).connected_rooms.get(i) != null:
			if dungeon.get(Vector2(0, 0)).connected_rooms.get(i).ending_room:
				next_to_start = true
	
	return (rooms_with_three_connections >= 2) != next_to_start
