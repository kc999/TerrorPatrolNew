class_name PlayerState extends State

const MOVE = "Move"

var player:Player

func _ready()-> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The playerstate state type must be used in the player scene. It needs its owner to be a player node.")
