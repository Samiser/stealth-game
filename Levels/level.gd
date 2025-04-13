extends Node2D

@onready var path = $Path
@onready var collectables = $Collectables
var player: Node2D = null
var collected_count: int = 0
var end_unlocked: bool = false

signal player_reached_end()

func _ready() -> void:
	path.tile_clicked.connect(_on_path_tile_clicked)
	path.tile_entered.connect(_on_path_tile_entered)
	collectables.z_index = 10
	
	for collectable in collectables.get_children():
		collectable.collected.connect(_collected)

func start(p) -> void:
	player = p
	player.path = path
	player.set_start(path.start)

func _on_path_tile_clicked(tile: Area2D) -> void:
	player.handle_tile_click(tile)
	
func _on_path_tile_entered(tile: Area2D, area: Area2D):
	if area == player.area and tile == path.end:
		print("reached end!")
		emit_signal("player_reached_end")
		path.clear()

func _collected():
	collected_count += 1
	
	if collected_count >= collectables.get_child_count():
		_unlock_end()

func _unlock_end():
	path.show_end()
	end_unlocked = true
