extends Node2D

# Will load and unload rooms and handle logic related
class_name LevelLoader

# Will be set from LDtkImporter
export var base_path: String
export var save_extension: String

# Should be the level identifier from LDtk
export(String) var start_room: String

# Scale the rooms to match other objects, such as player objects
export(Vector2) var level_scale: Vector2

# Nodepath to the camera and if camera is in a child scene it'll try to find a Camera2D object in that scene named Camera2D.
export(NodePath) var camera_nodepath: NodePath
# Nodepath to player object
export(NodePath) var player_nodepath: NodePath

onready var queue := preload("res://addons/LDtk-Importer/Nodes/resourceQueue.gd").new()

var camera: Camera2D = null
var player: Node2D = null

var current_level: Level = null
var loaded_level_ids: Array = []

func _ready():
	if get_node(camera_nodepath) is Camera2D:
		camera = get_node(camera_nodepath)
	else:
		camera = get_node(camera_nodepath).find_node("Camera2D")
	
	if player_nodepath != null:
		player = get_node(player_nodepath)
	
	queue.start()
	_enter_room(start_room, "",true)

# Convinience method for getting level paths
func _get_level_path(name: String) -> String:
	return "%s%s%s" % [base_path, name, save_extension]

func _enter_room(level, target_door, start: bool):
	var previous_level = current_level
	if not start:
		var new_level = queue.get_resource(_get_level_path(level))
		if not new_level:
			new_level = queue.get_resource(_get_level_path(level))
		
		current_level = new_level.instance()
	else:
		current_level = ResourceLoader.load(_get_level_path(level)).instance()
	
	current_level.scale = level_scale
	current_level.position = current_level.level_offset * level_scale
	
	add_child(current_level)
	
	if previous_level:
		previous_level.queue_free()
	
	if not start:
		for target_room_door in current_level.doors.get_children():
			if target_room_door.identifier == target_door:
				player.position = target_room_door.get_enter_position(level_scale)
	elif player and current_level.player_spawn_position != null:
		player.position = current_level.player_spawn_position.position * level_scale
	
	# Set camera limits
	var camera_bounds = current_level.get_offseted_camera_bounds()
	camera.limit_left = camera_bounds.position.x * level_scale.x
	camera.limit_top = camera_bounds.position.y * level_scale.y
	camera.limit_right = camera_bounds.end.x * level_scale.x
	camera.limit_bottom = camera_bounds.end.y * level_scale.y
	
	var connected_levels = current_level.get_connected_level()
	
	var rooms_to_load = Array()
	var rooms_to_unload = Array()
	
	for loaded_level in loaded_level_ids:
		if not connected_levels.has(loaded_level):
			unload_level(loaded_level)
		
	for connected_level in connected_levels:
		if not loaded_level_ids.has(connected_level):
			load_level(connected_level)
	
	for door in current_level.doors.get_children():
		door.connect("door_entered", self, "door_entered")
	
func unload_level(level):
	loaded_level_ids.erase(level)
	queue.cancel_resource(_get_level_path(level))

func load_level(level):
	loaded_level_ids.append(level)
	queue.queue_resource(_get_level_path(level), false)

func door_entered(door):
	if queue.is_ready(_get_level_path(door.target_level_identifier)):
		_enter_room(door.target_level_identifier, door.target_door_identifier, false)
	else:
		# TODO: Add logic which retries in progress loop
		print("not loaded")
