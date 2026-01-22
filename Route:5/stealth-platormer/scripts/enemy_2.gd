extends CharacterBody2D

@export var WALKSPEED : float = 80.0
@export var RUNSPEED : float = 130.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var idletimer: Timer = $idletimer
@onready var normalsound: AudioStreamPlayer2D = $normalsound
@onready var proximityrange: Sprite2D = $proximityrange

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")

enum STATE {IDLE,PATROL,ALERT,STUN}

var direction = 1
var speed : float = 0.0
var state :STATE = STATE.PATROL
var playerfound : bool = false
var run_detectrange : float = 460
var walk_detectrange : float = 230.0
var breath_detectrange : float = 115.0

func _ready() -> void:
	animated_sprite_2d.flip_h = true
	Global.horn_off.connect(_change_to_state.bind(STATE.PATROL))
	Global.horn_on.connect(_change_to_state.bind(STATE.STUN))

func _process(delta: float) -> void:
	if not player.radar_on:
		proximityrange.hide()
		return
	proximityrange.show()
	var distance = global_position.distance_to(player.global_position)
	if distance < run_detectrange and state != STATE.STUN:
		if player.is_running:
			_change_to_state(STATE.ALERT)
		else :
			if distance < walk_detectrange :
				if player.velocity != Vector2.ZERO :
					_change_to_state(STATE.ALERT)
				else:
					if distance < breath_detectrange :
						if player.in_noise_reduct_zone:
							return
						_change_to_state(STATE.ALERT)

func _physics_process(delta: float) -> void:
	match state:
		STATE.PATROL:
			_patrol()
		STATE.ALERT:
			_alert()
		STATE.STUN:
			_stunned()
	if  ray_cast.is_colliding():
		direction = -1
	elif ray_cast_2d_2.is_colliding():
		direction = 1
	if direction == 1:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false

func _idle():
	print("idle")
	if idletimer.time_left <= 0:
		idletimer.start()
	animated_sprite_2d.play("idle")

func _patrol():
	if not normalsound.playing:
		normalsound.playing = true
	normalsound.pitch_scale = 1.0
	normalsound.volume_db = 1.0
	if playerfound:
		_change_to_state(STATE.ALERT)
	else:
		speed = WALKSPEED
		velocity.x = direction * speed
		animated_sprite_2d.play("walk")
		move_and_slide()

func _alert():
	if not normalsound.playing:
		normalsound.playing = true
	normalsound.pitch_scale = 1.2
	normalsound.volume_db = 5.0
	animated_sprite_2d.play("alert")
	Global.player_died = true
	_change_to_state(STATE.PATROL)
	Global._reload()

func _stunned():
	if not normalsound.playing:
		normalsound.playing = true
	normalsound.pitch_scale = 1.4
	normalsound.volume_db = 2.0
	animated_sprite_2d.play("stun")

func _on_idletimer_timeout() -> void:
	state = STATE.PATROL

func _change_to_state(newstate : STATE):
	state = newstate
