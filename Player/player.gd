extends Node2D

var path: Node2D = null
var current_tile: Node2D = null
@onready var area: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	idle()

func idle():
	sprite.stop()
	sprite.play("idle_right")

func move_to_tile(tile: Node2D):
	sprite.stop()
	sprite.play("walk_right")
	var move_tween: Tween = get_tree().create_tween()
	move_tween.tween_property(
		self,
		"position",
		tile.global_position,
		1).set_trans(Tween.TRANS_SINE)
	move_tween.tween_callback(idle)
	current_tile = tile

func move_to_next_level(start: Node2D):
	sprite.stop()
	sprite.play("walk_right")
	var move_tween: Tween = get_tree().create_tween()
	move_tween.tween_property(
		self,
		"position",
		start.global_position,
		5).set_trans(Tween.TRANS_SINE)
	move_tween.tween_callback(idle)
	current_tile = start

func set_start(tile: Node2D):
	move_to_tile(tile)

func handle_tile_click(tile: Node2D):
	if tile in current_tile.neighbours:
		move_to_tile(tile)
