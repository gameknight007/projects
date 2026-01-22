extends CharacterBody2D


@export var WALK_SPEED : float = 80.0
@export var RUNSPEED : float = 150.0
@export var JUMP_VELOCITY = -300.0
@export var radar_on : bool = false

@onready var coyotetimer: Timer = $coyotetimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var breathsound: AudioStreamPlayer2D = $breathsound

var speed : float = 0.0
var is_running : bool = false
var is_walking : bool = false
var in_noise_reduct_zone : bool = false
var coyote_timer_active : bool = false

func _ready() -> void:
	Global.player = self

func _process(delta: float) -> void:
	is_running = Input.is_action_pressed("run") and velocity.x != 0
	is_walking = !is_running and velocity.x != 0
	if is_running:
		breathsound.pitch_scale = lerp(breathsound.pitch_scale,1.16,0.1)
	elif is_walking:
		breathsound.pitch_scale = lerp(breathsound.pitch_scale,1.05,0.1)
	else:
		breathsound.pitch_scale = lerp(breathsound.pitch_scale,1.0,0.1)

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("run"):
		speed = RUNSPEED
	else:
		speed = WALK_SPEED

func _physics_process(delta: float) -> void:
	if not Global.game_on or Dialoguemanager.dialogueactive :
		animated_sprite.play("idle")
		breathsound.stop()
		return
	if not breathsound.playing :
		breathsound.playing = true
	if Input.is_action_pressed("move_left"):
		if is_running:
			animated_sprite.play("run")
		else:
			animated_sprite.play("walk")
		velocity.x = -speed 
		animated_sprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		if is_running:
			animated_sprite.play("run")
		else:
			animated_sprite.play("walk")
		velocity.x = speed
		animated_sprite.flip_h = false
	else:
		animated_sprite.play("idle")
		velocity.x = 0
	if is_on_floor() :
		if coyote_timer_active:
			coyote_timer_active = false
			coyotetimer.stop()
	else:
		animated_sprite.play("jump")
		if !coyote_timer_active:
			coyotetimer.start()
			coyote_timer_active = true
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and (!coyotetimer.is_stopped() or is_on_floor()):
		velocity.y = JUMP_VELOCITY
		coyotetimer.stop()
		coyote_timer_active = true
	move_and_slide()
