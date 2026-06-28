class_name GunState extends State

const SHOOT = "Shoot"
const RELOAD = "Reload"
const EQUIP = "Equip"
const UNEQUIP = "UNEQUIP"
var gun:Gun

func _ready()-> void:
	await owner.ready
	gun = owner as Gun
	assert(gun != null, "The gun state type must be used in the gun scene. It needs its owner to be a gun node.")
