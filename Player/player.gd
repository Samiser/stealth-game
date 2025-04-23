extends Node2D

var path: Node2D = null
var current_tile: Node2D = null
var current_weapon: Node2D = null
var alive := true
var time_passed := 0.0
@onready var area := $Area2D
@onready var sprite := $AnimatedSprite2D
@onready var dagger := $Dagger

signal died()

func _drop_weapon():
	if current_weapon:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.tween_property(current_weapon, "global_position:y", global_position.y + 50, 0.2)
		tween.parallel().tween_property(current_weapon, "rotation_degrees", 80, 0.22)

func _die():
	alive = false
	emit_signal("died")
	sprite.stop()
	sprite.play("die_right")
	_drop_weapon()

func _reset_weapon():
	if current_weapon:
		current_weapon.rotation_degrees = 0
		current_weapon.global_position.y = global_position.y
		current_weapon.visible = false
		current_weapon = null

func reset():
	alive = true
	sprite.stop()
	sprite.play("idle_right")
	_reset_weapon()

func _process(delta: float) -> void:
	time_passed += delta
	if alive and current_weapon:
		var squish = sin(time_passed * 2.5) * 0.1
		current_weapon.position.y = current_weapon.position.y + squish
		current_weapon.rotation_degrees = current_weapon.rotation_degrees + squish / 2

func _attack():
	if current_weapon:
		var tween := create_tween()
		tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.tween_property(current_weapon, "rotation_degrees", 80, 0.05)
		tween.tween_property(current_weapon, "rotation_degrees", 0, 0.2).set_delay(0.05)

func _grab_weapon(weapon):
	if weapon == "dagger":
		current_weapon = dagger
	
	if current_weapon:
		current_weapon.global_position.y = global_position.y
		current_weapon.visible = true

func _on_area_entered(entered_area: Area2D):
	if alive:
		if entered_area.is_in_group("attack") and entered_area.get_parent().alive:
			_die()

		elif entered_area.is_in_group("weakness") and entered_area.get_parent().alive and current_weapon != null:
			_attack()

		elif entered_area.get_parent().is_in_group("weapon"):
			if entered_area.get_parent().is_in_group("dagger"):
				_grab_weapon("dagger")

func _ready() -> void:
	idle()
	area.area_entered.connect(_on_area_entered)

func idle():
	if alive:
		sprite.stop()
		sprite.play("idle_right")

func move_to_tile(tile: Node2D):
	sprite.stop()
	sprite.play("walk_right")
	var move_tween: Tween = get_tree().create_tween()
	move_tween.tween_property(
		self,
		"position",
		tile.global_position,
		0.5).set_trans(Tween.TRANS_SINE)
	move_tween.tween_callback(idle)
	current_tile = tile

func _set_current_tile(tile: Node2D):
	current_tile = tile

func move_to_next_level(level: Node2D):
	var start = level.path.start
	sprite.stop()
	sprite.play("walk_right")
	var move_tween: Tween = get_tree().create_tween()
	move_tween.tween_property(
		self,
		"position",
		start.global_position,
		5).set_trans(Tween.TRANS_SINE)
	move_tween.tween_callback(func(): _set_current_tile(start))

func set_start(tile: Node2D):
	move_to_tile(tile)

func teleport_to_tile(tile: Node2D):
	position = tile.global_position
	_set_current_tile(tile)

func handle_tile_click(tile: Node2D):
	if tile in current_tile.neighbours and alive:
		move_to_tile(tile)
