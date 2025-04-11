extends Node2D

var path: Node2D = null
var current_tile: Node2D = null
@onready var area: Area2D = $Area2D

func move_to_tile(tile: Node2D):
	var move_tween: Tween = get_tree().create_tween()
	move_tween.tween_property(
		self,
		"position",
		tile.global_position,
		0.3).set_trans(Tween.TRANS_SINE)
	current_tile = tile

func set_start(tile: Node2D):
	move_to_tile(tile)

func handle_tile_click(tile: Node2D):
	if tile in current_tile.neighbours:
		move_to_tile(tile)
