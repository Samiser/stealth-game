extends Node2D

@onready var levels: Array[Node2D] = [$LevelOne]
@onready var win_label: Label = $WinMessage
@onready var player: Node2D = $Player
@onready var exit: Node2D = $Exit

var current_level = 0

func _ready() -> void:
	for level in levels:
		if level.has_signal("player_reached_end"):
			level.player_reached_end.connect(_on_finished_level)
	
	levels[current_level].start(player)

func _on_finished_level(level: Node2D):
	win_label.visible = true
	player.move_to_next_level(exit)
