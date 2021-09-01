extends Node2D

# Holding values and some logic regarding the levels imported from LDtk
class_name Level

# Nodepath for the player spawning position, should be a Position2D object
export(NodePath) var player_spawn_nodepath: NodePath
var player_spawn_position: Position2D = null

# Should be set by LDtk importer
export var level_offset: Vector2 = Vector2.ZERO
export var room_size: Vector2 = Vector2.ZERO

func _ready():
	if player_spawn_nodepath != null:
		player_spawn_position = get_node(player_spawn_nodepath)

# Returns the offseted camera bounds
func get_offseted_camera_bounds() -> Rect2:
	return Rect2(
		level_offset.x,
		level_offset.y,
		room_size.x,
		room_size.y
	)

func get_connected_rooms() -> Array:
	return []
