extends Node2D

@onready var levels: Array[Node2D] = [$LevelOne]
@onready var win_label: Label = $WinMessage

func _ready() -> void:
	for level in levels:
		if level.has_signal("player_reached_end"):
			level.player_reached_end.connect(_on_finished_level)

func _on_finished_level(level: Node2D):
	win_label.visible = true
	
