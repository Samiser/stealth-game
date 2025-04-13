extends Area2D

@onready var color_rect: ColorRect = $ColorRect
@export var neighbours: Array[Node2D] = []
var occupied = false

signal tile_clicked(tile: Area2D)

func tween_to_color(target_color: Color):
	var tween := create_tween()
	var start_color := color_rect.color

	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(
		func (c): color_rect.color = c,  # Callback for color interpolation
		start_color,
		target_color,
		0.5
	)
	
	tween.parallel().tween_property(color_rect, "scale", Vector2(1.2, 1.2), 0.2)
	tween.tween_property(color_rect, "scale", Vector2(1, 1), 0.2)

func stop():
	$CollisionShape2D.free()

func _ready() -> void:
	color_rect.set_pivot_offset(color_rect.size / 2)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		emit_signal("tile_clicked", self)
