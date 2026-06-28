class_name Gun extends Node3D

##How long of a cooldown between shots
@export var rateOfFire: float
@export var maxAmmoMagazine: int
@export var currentAmmo: int
@export var reserveAmmo: int
@export var damage: float
##Scene for projectile object weapon shoots
@export var projectileScene: PackedScene
var rateOfFireTimer: Timer
var canShoot: bool = true
##Emits when the gun has successfully been reloaded
signal gunReloaded
signal gunEquipped
signal gunUnequipped

func _ready() -> void:
	rateOfFireTimer = Timer.new()
	rateOfFireTimer.wait_time = rateOfFire
	rateOfFireTimer.one_shot = true
	rateOfFireTimer.autostart = false
	add_child(rateOfFireTimer)
	rateOfFireTimer.timeout.connect(_on_fireratetimer_timeout)
func shoot() -> void:
	print("Pew")
	canShoot = false
	rateOfFireTimer.start()
	currentAmmo -= 1
	print(currentAmmo)
	
func reload() -> void:
	print("reloaded")

func _on_fireratetimer_timeout () -> void:
	canShoot = true
