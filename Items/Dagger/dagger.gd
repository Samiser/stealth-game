extends Node2D

@onready var area: Area2D = $Area2D

func _collect() -> void:
	await get_tree().create_timer(1.0).timeout
	self.free()

func _ready() -> void:
	area.area_entered.connect(_on_area_entered)

func _on_area_entered(enterer: Area2D) -> void:
	var parent = enterer.get_parent()
	if parent.is_in_group("player"):
		_collect()
