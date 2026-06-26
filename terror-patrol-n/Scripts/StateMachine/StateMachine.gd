class_name StateMachine extends Node
##State entered when first entering the scene
@export var initial_state: State = null

##The current state of the state machine
##If an initial state isn't set, grab the first state node under the state machine
@onready var state: State = (func get_initial_state()-> State:
	return initial_state if initial_state != null else get_child(0)
	).call()
	
func _ready() -> void:
	#Give every state a reference to the state machine
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
		
	##Wait for the owner object to be ready to start grabbing data
	await owner.ready
	state.enter("")
##Handle unhandled Input
func _unhandled_input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return
	state.handle_input(event)
##Handle process update
func _process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	state.update(delta)
##Handle physics process update
func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	state.physics_update(delta)

##Transition to the next state when signal is encounter and pass along relevant information
func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if !is_multiplayer_authority():
		return
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return
	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
