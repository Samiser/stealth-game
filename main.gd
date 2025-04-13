extends Node2D

@onready var levels: Node2D = $Levels
@onready var win_label: Label = $WinMessage
@onready var player: Node2D = $Player
@onready var exit: Node2D = $Exit
@onready var camera: Camera2D = $Camera2D

var current_level = 0

func _ready() -> void:
	for level in levels.get_children():
		level.player = player
		if level.has_signal("player_reached_end"):
			level.player_reached_end.connect(_on_finished_level)
	
	levels.get_children()[current_level].start(player)

func _on_finished_level():
	current_level += 1
	win_label.visible = true
	player.move_to_next_level(levels.get_children()[current_level])
	_move_camera_to(levels.get_children()[current_level])
	
func _move_camera_to(node: Node2D):
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "position", node.position, 3)
