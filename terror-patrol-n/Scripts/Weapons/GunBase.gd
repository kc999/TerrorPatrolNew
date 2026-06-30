class_name Gun extends Node3D

##How long of a cooldown between shots
@export var rateOfFire: float
@export var maxAmmoMagazine: int
@export var currentAmmo: int
@export var reserveAmmo: int
@export var damage: float
@export var mouseRecoilVert: float
@export var mouseRecoilHorz: float
@export var springRecoilHorz: float
@export var springRecoilVert: float
##Scene for projectile object weapon shoots
@export var projectileScene: PackedScene
@export var baseGunSound: AudioStream
@export var tailIndoorSound: AudioStream
@export var tailOutdoorSound: AudioStream
@export var baseSoundVolume: float = 1.0
var baseGunSoundPlayer: AudioStreamPlayer
var tailIndoorSoundPlayer: AudioStreamPlayer
var tailOutdoorSoundPlayer: AudioStreamPlayer
var rateOfFireTimer: Timer
var canShoot: bool = true
var player: Player
#Gun sounds are routed through the "WeaponSounds" bus. This is to properly pan sound shooting sound effecs
var audioBusIndoor: String = "WeaponSoundsIndoor"
var audioBusOutdoor: String = "WeaponSoundsOutdoor"
var busPanEffectIn
var busPanEffectOut
##Emits when the gun has successfully been reloaded
signal gunReloaded
signal gunEquipped
signal gunUnequipped

func _ready() -> void:
	#Create the timer to track rate of fire
	rateOfFireTimer = Timer.new()
	rateOfFireTimer.wait_time = rateOfFire
	rateOfFireTimer.one_shot = true
	rateOfFireTimer.autostart = false
	add_child(rateOfFireTimer)
	rateOfFireTimer.timeout.connect(_on_fireratetimer_timeout)
	#Grab a reference to the player
	player = get_tree().get_first_node_in_group("Player")
	#Check if there are gun sounds attached, if there are, create necessary players for them
	if baseGunSound:
		baseGunSoundPlayer = AudioStreamPlayer.new()
		baseGunSoundPlayer.stream = baseGunSound
		baseGunSoundPlayer.max_polyphony = 3
		add_child(baseGunSoundPlayer)
	if tailIndoorSound:
		tailIndoorSoundPlayer = AudioStreamPlayer.new()
		tailIndoorSoundPlayer.stream = tailIndoorSound
		tailIndoorSoundPlayer.max_polyphony = 1
		tailIndoorSoundPlayer.bus = audioBusIndoor
		add_child(tailIndoorSoundPlayer)
	if tailOutdoorSound:
		tailOutdoorSoundPlayer = AudioStreamPlayer.new()
		tailOutdoorSoundPlayer.stream = tailOutdoorSound
		tailOutdoorSoundPlayer.max_polyphony = 1
		tailOutdoorSoundPlayer.bus = audioBusOutdoor
		add_child(tailOutdoorSoundPlayer)
	#Get pan effect from the bus
	busPanEffectIn = AudioServer.get_bus_effect(AudioServer.get_bus_index(audioBusIndoor),0) as AudioEffectPanner
	busPanEffectOut = AudioServer.get_bus_effect(AudioServer.get_bus_index(audioBusOutdoor),0) as AudioEffectPanner
func shoot() -> void:
	canShoot = false
	rateOfFireTimer.start()
	if player:
		player.apply_recoil(mouseRecoilVert,randf_range(-mouseRecoilHorz,mouseRecoilHorz),springRecoilVert,randf_range(-springRecoilHorz,springRecoilHorz))
	if baseGunSoundPlayer:
		baseGunSoundPlayer.pitch_scale = randf_range(0.9,1.1)
		baseGunSoundPlayer.play()
	var soundInfo = player.get_sound_acoustics()
	print(soundInfo)
	if tailIndoorSoundPlayer:
		tailIndoorSoundPlayer.volume_db = linear_to_db(soundInfo["indoor_volume"])
		busPanEffectIn.pan = soundInfo["pan"]
		tailIndoorSoundPlayer.play()
	if tailOutdoorSoundPlayer:
		tailOutdoorSoundPlayer.volume_db = linear_to_db(soundInfo["outdoor_volume"])
		busPanEffectOut.pan = -soundInfo["pan"]
		tailOutdoorSoundPlayer.play()
		
func reload() -> void:
	print("reloaded")

func _on_fireratetimer_timeout () -> void:
	canShoot = true
