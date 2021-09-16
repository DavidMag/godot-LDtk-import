extends Area2D

class_name Door

# Signal triggered when player enters the door with this door as parameter
signal door_entered

# All export variables are loaded from import script
export var identifier: String
export var enter_direction: String
var _enter_multiplicator: Vector2

export var target_level_identifier: String
export var target_door_identifier: String

func _ready():
	match enter_direction:
		"LEFT":
			_enter_multiplicator = Vector2.LEFT * 1.5
		"TOP":
			# Make top down since Godot is a special little child who thinks positive is down
			_enter_multiplicator = Vector2.DOWN * 1.5
		"BOTTOM":
			# Make down up since Godot is a special little child who thinks positive is down
			_enter_multiplicator = Vector2.UP * 1.5
		"RIGHT":
			_enter_multiplicator = Vector2.RIGHT * 1.5
	
	connect("body_entered", self, "body_entered_listener")

func body_entered_listener(body):
	emit_signal("door_entered", self)

# Use this to now where the player should be placed when this door is the target
func get_enter_position(level_scale):
	return get_child(0).global_position + get_child(0).shape.extents * level_scale * 2 * _enter_multiplicator
