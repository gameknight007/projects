extends Node2D

@export var bulletscene : PackedScene
@export var damage = 10.0

@onready var gunsprite: Sprite2D = $pivot/gunsprite
@onready var muzzle: Marker2D = $pivot/gunsprite/muzzle
@onready var shoottimer: Timer = $shoottimer
@onready var shootsound: AudioStreamPlayer2D = $shootsound
@onready var player = get_tree().get_first_node_in_group("PLAYER")

var enemies_in_range = []
var firerate = 0.8
var bulletsize = 1.0
var bulletspeed  = 600.0
var bulletrange = 350.0
@export var bulletcount : int = 1
@export_range(0, 360) var arc : float = 0.0


func _physics_process(_delta: float) -> void:
#region gunspritedirection
	var direction = gunsprite.global_position - global_position
	player.gundirection = direction
	if direction.x > 0 :
		gunsprite.flip_v = false
		muzzle.position = Vector2(119,-12)
	else:
		gunsprite.flip_v = true
		muzzle.position = Vector2(119,12)
#endregion
#region enemydetection
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("SHOOT"):
		if !shoottimer.is_stopped() :
			return
		_shoot()
#endregion

func _shoot():
	shootsound.play()
	for i in bulletcount:
		var bullet = bulletscene.instantiate()
		bullet.global_position = muzzle.global_position
		
		if bulletcount == 1:
			bullet.global_rotation = muzzle.global_rotation
		else:
			var incriment = deg_to_rad(arc)/(bulletcount - 1)
			bullet.global_rotation = (
				muzzle.global_rotation 
				+ incriment * i - 
				deg_to_rad(arc)/2
			)
		bullet.SPEED = bulletspeed
		bullet.RANGE = bulletrange
		bullet.damage = damage 
		bullet.scale = Vector2(bulletsize,bulletsize)
		get_tree().current_scene.add_child(bullet)
		shoottimer.start(1.5 - firerate)
		

func _on_shoottimer_timeout() -> void:
	pass
