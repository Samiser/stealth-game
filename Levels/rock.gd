extends Node2D

@onready var reveal: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D

func _on_area_entered(area: Area2D):
	if area.get_parent().is_in_group("player"):
		sprite.modulate.a = 0.5

func _on_area_exited(area: Area2D):
	if area.get_parent().is_in_group("player"):
		sprite.modulate.a = 1

func _ready() -> void:
	reveal.area_entered.connect(_on_area_entered)
	reveal.area_exited.connect(_on_area_exited)
