extends Area2D

@onready var color_rect: ColorRect = $ColorRect

@export var neighbours: Array[Node2D] = []
var occupied = false

signal tile_clicked(tile: Area2D)
signal tile_entered(tile: Area2D, area: Area2D)

func set_color(color: Color):
	color_rect.color = color

func _ready() -> void:
	print("node ready")

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		emit_signal("tile_clicked", self)
