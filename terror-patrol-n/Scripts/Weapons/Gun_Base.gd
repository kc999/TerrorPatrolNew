class_name Gun extends Node3D

##How long of a cooldown between shots
@export var rateOfFire: float
@export var maxAmmo: int
@export var currentAmmo: int
@export var reserveAmmo: int
@export var damage: float
##Scene for projectile object weapon shoots
@export var projectileScene: PackedScene
var rateOfFireTimer: Timer
var canShoot: bool = true
##Emits when the gun has successfully been reloaded
signal gunReloaded
func _ready() -> void:
	rateOfFireTimer = Timer.new()
	rateOfFireTimer.wait_time = rateOfFire
	rateOfFireTimer.one_shot = true
	rateOfFireTimer.autostart = false
	add_child(rateOfFireTimer)

func shoot() -> void:
	pass
	
func reload() -> void:
	pass
