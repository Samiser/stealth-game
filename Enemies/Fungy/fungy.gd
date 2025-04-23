@tool
extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var vision: Area2D = $Vision
@onready var weakness: Area2D = $Weakness
@onready var explosion_particles: GPUParticles2D = $GPUParticles2D

var has_attacked = false
var alive = true

@export var flipped := false:
	set(value):
		flipped = value
		_flip()

func _flip():
	if not self.is_inside_tree():
		return
	sprite.flip_h = !sprite.flip_h
	vision.position.x = -vision.position.x
	weakness.rotate(PI)

func _idle():
	sprite.stop()
	sprite.play("idle_right")
	
func _explode():
	explosion_particles.emitting = true;
	_idle()

func _jump_to_and_explode(node: Node2D):
	sprite.z_index = 0
	sprite.stop()
	sprite.play("jump_right")
	var move_tween: Tween = get_tree().create_tween()
	move_tween.tween_property(
		self,
		"global_position",
		node.global_position,
		0.3).set_trans(Tween.TRANS_SINE)
	move_tween.tween_callback(_explode)

func _attack(player: Node2D):
	_jump_to_and_explode(player)
	has_attacked = true

func _on_vision_entered(area: Area2D):
	var parent = area.get_parent()
	if parent.is_in_group("player"):
		if has_attacked == false and alive:
			_attack(parent)

func _die():
	if alive:
		await get_tree().process_frame
		alive = false
		sprite.stop()
		sprite.play("die_right")

func _on_weakness_entered(area: Area2D):
	var parent = area.get_parent()
	if parent.is_in_group("player"):
		if parent.current_weapon != null:
			_die()
		else:
			_explode()
			has_attacked = true

func _ready() -> void:
	sprite.play("idle_right")
	
	if flipped:
		_flip()
	
	vision.area_entered.connect(_on_vision_entered)
	weakness.area_entered.connect(_on_weakness_entered)
	
