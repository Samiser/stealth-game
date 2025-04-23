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

func _input(event):
	if event.is_action_pressed("reset"):
		_reset_level()

func _reset_level():
	var old_level = levels.get_children()[current_level]
	var old_level_position = old_level.global_position
	var new_level = old_level.reset()
	new_level.global_position = old_level_position
	new_level.player = player
	new_level.player_reached_end.connect(_on_finished_level)
	player.path = new_level.path
	player.teleport_to_tile(new_level.path.start)
	player.reset()

func _on_finished_level():
	current_level += 1
	if current_level >= levels.get_child_count():
		win_label.visible = true
	else:
		_zoom_to(player)
		await get_tree().create_timer(5.0).timeout
		player.move_to_next_level(levels.get_children()[current_level])
		_move_camera_to(levels.get_children()[current_level])

func _move_and_zoom(node, zoom, move_seconds):
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(camera, "zoom", zoom, 1)
	tween.parallel().tween_property(camera, "position", node.position, move_seconds)

func _move_camera_to(node: Node2D):
	_move_and_zoom(node, Vector2(1.2, 1.2), 3)

func _zoom_to(node: Node2D):
	_move_and_zoom(node, Vector2(3, 3), 1)
	
