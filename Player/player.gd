extends Node2D

var path: Node2D = null
var current_tile: Node2D = null
var alive = true
@onready var area: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

signal died()

func _die():
	alive = false
	emit_signal("died")
	sprite.stop()
	sprite.play("die_right")


func _on_area_entered(area: Area2D):
	if area.is_in_group("attack") and area.get_parent().alive:
		_die()

func _ready() -> void:
	idle()
	area.area_entered.connect(_on_area_entered)

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
		0.5).set_trans(Tween.TRANS_SINE)
	move_tween.tween_callback(idle)
	current_tile = tile

func _set_current_tile(tile: Node2D):
	current_tile = tile
	idle()

func move_to_next_level(level: Node2D):
	var start = level.path.start
	sprite.stop()
	sprite.play("walk_right")
	var move_tween: Tween = get_tree().create_tween()
	move_tween.tween_property(
		self,
		"position",
		start.global_position,
		5).set_trans(Tween.TRANS_SINE)
	move_tween.tween_callback(func(): _set_current_tile(start))

func set_start(tile: Node2D):
	move_to_tile(tile)

func handle_tile_click(tile: Node2D):
	if tile in current_tile.neighbours and alive:
		move_to_tile(tile)
