extends Node3D

var heldWeapons: Array[Gun] 
var equippedWeapon: Gun
@export var startingWeapon: PackedScene

func _ready() -> void:
	if startingWeapon:
		equippedWeapon = startingWeapon.instantiate()
		add_child(equippedWeapon)
