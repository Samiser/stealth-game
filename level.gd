extends Node2D

@onready var path = $Path
var player: Node2D = null

signal player_reached_end(level: Node2D)

func _ready() -> void:
	path.tile_clicked.connect(_on_path_tile_clicked)
	path.tile_entered.connect(_on_path_tile_entered)

func start(p) -> void:
	player = p
	player.path = path
	player.set_start(path.start)

func _on_path_tile_clicked(tile: Area2D) -> void:
	player.handle_tile_click(tile)
	
func _on_path_tile_entered(tile: Area2D, area: Area2D):
	if area == player.area and tile == path.end:
		print("reached end!")
		emit_signal("player_reached_end", self)
		path.clear()
