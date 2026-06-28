extends Node3D
#This node adds a bit of recoil that is then slowly snapped back.
#A small amount of recoil is then added to the mouse, making it feel more punchy

@export var snapSpeed: float = 12.0
@export var returnSpeed: float = 4.0

var currentRecoil: Vector3
var targetRecoil: Vector3

func _process(delta: float) -> void:
	targetRecoil = targetRecoil.lerp(Vector3.ZERO, returnSpeed * delta)
	currentRecoil = currentRecoil.lerp(targetRecoil, snapSpeed * delta)
	rotation = currentRecoil
	
func add_recoil(recoilVert: float, recoilHorz: float) -> void:
	targetRecoil += Vector3(deg_to_rad(recoilVert),deg_to_rad(recoilHorz),0)
