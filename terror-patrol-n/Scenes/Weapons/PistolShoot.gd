extends GunState

func handle_input(_event: InputEvent) -> void:
	#If the gun can shoot, and has ammo, shoot
	if Input.is_action_just_pressed("primary_fire") && gun.canShoot && gun.currentAmmo > 0:
		gun.shoot()
