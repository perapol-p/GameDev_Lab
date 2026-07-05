extends Node

@export var enemy_scene: PackedScene
var score

func _ready():
	pass

func game_over():
	$death.play()
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$HUD.show_game_over()
	$Music.volume_db = -5
	$plane.stop()

func new_game():
	$Music.volume_db = -14
	$plane.play()
	get_tree().call_group("Enemys", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$EnemyTimer.start()
	$ScoreTimer.start()

func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()

	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()

	enemy.position = enemy_spawn_location.position

	var direction = enemy_spawn_location.rotation + PI / 2

	direction += randf_range(-PI / 4, PI / 4)
	enemy.rotation = direction + PI / 2

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	
	add_child(enemy)
