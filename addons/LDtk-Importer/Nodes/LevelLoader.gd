extends Node2D

# Will load and unload rooms and handle logic related
class_name LevelLoader

# Will be set from LDtkImporter
export var base_path: String
export var save_extension: String

# Should be the level identifier from LDtk
export(String) var start_room: String

# Scale the rooms to match other objects, such as player objects
export(Vector2) var room_scale: Vector2

# Nodepath to the camera and if camera is in a child scene it'll try to find a Camera2D object in that scene named Camera2D.
export(NodePath) var camera_nodepath: NodePath
# Nodepath to player object
export(NodePath) var player_nodepath: NodePath

onready var queue := preload("res://addons/LDtk-Importer/Nodes/resourceQueue.gd").new()

var camera: Camera2D = null
var player: Node2D = null

var current_level: Level = null
var loaded_rooms: Array = []

func _ready():
	if get_node(camera_nodepath) is Camera2D:
		camera = get_node(camera_nodepath)
	else:
		camera = get_node(camera_nodepath).find_node("Camera2D")
	
	current_level = ResourceLoader.load(_get_level_path(start_room)).instance()
	current_level.scale = room_scale
	
	add_child(current_level)
	
	if player_nodepath != null:
		player = get_node(player_nodepath)
		
		if current_level.player_spawn_position != null:
			player.position = current_level.player_spawn_position.position * room_scale
	
	queue.start()
	
	_enter_room()

# Convinience method for getting level paths
func _get_level_path(name: String) -> String:
	return "%s%s%s" % [base_path, name, save_extension]

func _enter_room():
	# Set camera limits
	var camera_bounds = current_level.get_offseted_camera_bounds()
	camera.limit_left = camera_bounds.position.x * room_scale.x
	camera.limit_top = camera_bounds.position.y * room_scale.y
	camera.limit_right = camera_bounds.size.x * room_scale.x
	camera.limit_bottom = camera_bounds.size.y * room_scale.y

func _get_connected_rooms():
	var connected_rooms = current_level.get_connected_rooms()
