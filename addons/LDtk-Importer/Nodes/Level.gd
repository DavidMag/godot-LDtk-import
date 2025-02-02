extends Node2D

# Holding values and some logic regarding the levels imported from LDtk
class_name Level

# Nodepath for the player spawning position, should be a Position2D object
export(NodePath) var player_spawn_nodepath: NodePath
var player_spawn_position: Position2D = null

# Should be set by LDtk importer
export var level_offset: Vector2 = Vector2.ZERO
export var room_size: Vector2 = Vector2.ZERO

onready var doors: Node2D = get_node("AutoGenerated/Doors")

func _ready():
	if player_spawn_nodepath != "":
		player_spawn_position = get_node(player_spawn_nodepath)

# Returns the offseted camera bounds
func get_offseted_camera_bounds() -> Rect2:
	return Rect2(
		level_offset.x,
		level_offset.y,
		room_size.x,
		room_size.y
	)

func get_connected_level() -> Array:
	var conntected_level = Array()
	
	for door in doors.get_children():
		if not conntected_level.has(door.target_level_identifier):
			conntected_level.append(door.target_level_identifier)
	
	return conntected_level
