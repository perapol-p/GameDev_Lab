extends Area3D

@export var next_scene : PackedScene

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") && next_scene != null:
		get_tree().change_scene_to_packed(next_scene)
