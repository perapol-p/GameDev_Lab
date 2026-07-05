extends CharacterBody2D

signal hit

@export var speed = 100
@export var rotation_speed = 1.0

var screen_size
var rotation_diraction = 0
var is_dead = false

func _ready() -> void:
	hide()
	screen_size = get_viewport_rect().size
	$CollisionShape2D.disabled = false

func get_input():
	rotation_diraction = Input.get_axis("move_left", "move_right")
	velocity = transform.y * -speed
	
func _physics_process(delta: float):
	if is_dead: 
		return
	
	get_input()
	rotation += rotation_diraction * rotation_speed * delta
	move_and_slide()
	update_animation()

func update_animation():
	var sprite = $AnimatedSprite2D
	var current_anim = sprite.animation
	
	if current_anim in ["turn_left", "turn_right"]:
		var max_frames = sprite.sprite_frames.get_frame_count(current_anim)
		if sprite.frame == max_frames - 1:
			sprite.frame = max_frames - 2

	match rotation_diraction:
		-1.0:
			if current_anim == "turn_right":
				reverse_or_switch(sprite, "turn_left")
			elif current_anim != "turn_left" or sprite.get_playing_speed() < 0:
				sprite.play("turn_left")
				
		1.0:
			if current_anim == "turn_left":
				reverse_or_switch(sprite, "turn_right")
			elif current_anim != "turn_right" or sprite.get_playing_speed() < 0:
				sprite.play("turn_right")
				
		0.0:
			if current_anim in ["turn_left", "turn_right"]:
				reverse_or_switch(sprite, "flying")
			elif current_anim != "flying":
				sprite.play("flying")

func reverse_or_switch(sprite: AnimatedSprite2D, target_anim: String):
	if sprite.frame == 0:
		sprite.play(target_anim)
	elif sprite.get_playing_speed() > 0 or not sprite.is_playing():
		sprite.play_backwards(sprite.animation)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	death()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	if is_dead:
		return
	death()

func death() -> void:
	is_dead = true
	hit.emit()
	$AnimatedSprite2D.play("death")
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	await $AnimatedSprite2D.animation_finished
	hide()

func start(pos):
	is_dead = false
	position = pos
	rotation = 0
	show()
	print(visible)
	$Area2D/CollisionShape2D.set_deferred("disabled", false)
