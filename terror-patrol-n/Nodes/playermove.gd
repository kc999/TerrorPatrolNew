extends PlayerState

func _input(event: InputEvent) -> void:
	player.move_player(get_process_delta_time())
