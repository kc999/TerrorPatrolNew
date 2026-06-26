class_name State extends Node

##Virtual base for all classes
##Emitted when the state is finished and transitioning to the next state
signal finished(next_state_path:String, data: Dictionary)
##Handles unhandled input 
func handle_input(_event: InputEvent) -> void:
	pass
##Runs every frame
func update(_delta: float) -> void:
	pass
##Runs every physics frame
func physics_update(_delta: float) -> void:
	pass
##Run when the state machine enters this state
func enter(previous_state_path: String, data:= {}) -> void:
	pass
##Run when the state machine leaves this class, and emits signal "finished"
func exit()-> void:
	pass
