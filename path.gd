@tool
extends Node2D

signal tile_clicked(tile: Node2D)
signal tile_entered(tile: Area2D, area: Area2D)

@export var start: Area2D
@export var end: Area2D

func _on_tile_clicked(tile: Node2D):
	emit_signal("tile_clicked", tile)

func _on_tile_entered(tile: Area2D, area: Area2D):
	emit_signal("tile_entered", tile, area)

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	end.set_color(Color.GOLDENROD)

	for tile in get_children():
		if tile.has_signal("tile_clicked"):
			tile.tile_clicked.connect(_on_tile_clicked)

		if tile.has_signal("tile_entered"):
			tile.area_entered.connect(func(area): _on_tile_entered(tile, area))

func clear() -> void:
	for tile in get_children():
		tile.stop()

func _process(delta: float) -> void:
	queue_redraw()

func _draw():
	var paths = []

	for tile in get_children():
		var tile_pos = to_local(tile.global_position)
		for neighbour in tile.neighbours:
			if neighbour == null:
				continue

			var tile_id = tile.get_instance_id()
			var neighbour_id = neighbour.get_instance_id()
			var path = [min(tile_id, neighbour_id), max(tile_id, neighbour_id)]

			if path in paths:
				continue
			else:
				paths.append(path)

			if not tile in neighbour.neighbours:
				push_warning("Non-bidirectional link: '%s' lists '%s' as a neighbour, but not vice versa." % [
					tile.name, neighbour.name
				])
				continue

			var neighbour_pos = to_local(neighbour.global_position)
			draw_line(tile_pos, neighbour_pos, Color("#735B42"), 10.0)
