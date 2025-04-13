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

	for tile in get_children():
		if tile.has_signal("tile_clicked"):
			tile.tile_clicked.connect(_on_tile_clicked)

		if tile.has_signal("area_entered"):
			tile.area_entered.connect(func(area): _on_tile_entered(tile, area))

func clear() -> void:
	for tile in get_children():
		tile.stop()

func show_end():
	end.tween_to_color(Color.GOLDENROD)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw_bidirectional_link(tile, neighbour, links):
	var tile_id = tile.get_instance_id()
	var neighbour_id = neighbour.get_instance_id()
	var link = [min(tile_id, neighbour_id), max(tile_id, neighbour_id)]

	if not tile in neighbour.neighbours:
		push_warning("Non-bidirectional link: '%s' lists '%s' as a neighbour, but not vice versa." % [
			tile.name, neighbour.name
		])
		return links

	if link in links:
		return links
	else:
		links.append(link)

	var tile_pos = to_local(tile.global_position)
	var neighbour_pos = to_local(neighbour.global_position)
	draw_line(tile_pos, neighbour_pos, Color("#735B42"), 10.0)
	return links

func _draw_bidirectional_links(tile, links):
	for neighbour in tile.neighbours:
		if neighbour != null:
			links = _draw_bidirectional_link(tile, neighbour, links)
	
	return links

func _draw():
	var links = []

	for tile in get_children():
		links = _draw_bidirectional_links(tile, links)
		
