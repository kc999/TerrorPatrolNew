extends PlayerState

func handle_input(_event: InputEvent) -> void:
	player.mouse_input(_event)

func _physics_process(delta: float) -> void:
	player.move_player(get_physics_process_delta_time())
