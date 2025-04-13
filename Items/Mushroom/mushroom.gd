extends Node2D

@export var squish_speed := 2.0
@export var squish_amount := 0.05

@onready var area = $Area2D
@onready var sprite = $Sprite2D

signal collected()

var time_passed := 0.0
var base_scale : Vector2

func _ready():
	base_scale = scale
	time_passed += float(randi() % 10)
	
	area.area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	time_passed += delta
	var squish = sin(time_passed * squish_speed) * squish_amount
	scale = Vector2(base_scale.x, base_scale.y + squish)

func _on_area_entered(enterer: Area2D):
	var parent = enterer.get_parent()
	if parent.is_in_group("player"):
		_collect()

func _collect():
	_play_collection_animation()
	emit_signal("collected")

func _play_collection_animation():
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", position + Vector2(0, -50), 0.3)
	tween.tween_property(self, "scale", scale * 1.3, 0.4)
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.4)
	tween.tween_callback(Callable(self, "queue_free"))
