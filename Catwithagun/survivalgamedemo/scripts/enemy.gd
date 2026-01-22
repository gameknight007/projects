extends CharacterBody2D

@onready var player = get_tree().get_first_node_in_group("PLAYER")
@onready var softcollision = $softcollision
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitsound: AudioStreamPlayer = $hitsound
@onready var enemysprite: Sprite2D = $enemysprite
@onready var damagenumberpos: Node2D = $damagenumberpos
@onready var deathtimer: Timer = $deathtimer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animplayercharacter: AnimationPlayer = $animplayercharacter

@export var deatheffect : PackedScene
@export var speed = 150.0
@export var maxhealth = 17.0
@export var expscene : PackedScene
var health = 0.0
var knockbackforce = Vector2.ZERO
var bullet_hit = false
var expvalue = 1


func _ready() -> void:
	health = maxhealth

func _physics_process(_delta: float) -> void:
#region directionandmovement
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	if direction.x > 0:
		enemysprite.flip_h = false
	else:
		enemysprite.flip_h = true
#endregion
#sofcollision
	if softcollision._is_colliding() :
		velocity += softcollision._get_push_vector() * 30.0
#knockbackonbullethit
	if bullet_hit:
		velocity += knockbackforce
		bullet_hit = false
	move_and_slide()

func _Gothit(damage,force):
	animation_player.play("hit")
	health -= damage
	knockbackforce = force
	Damagenumberdisplay._Displaynumbers(damage,damagenumberpos.global_position,Color.RED)
	if health <= 0 :
		hitsound.play()
		call_deferred("DIE")

func DIE():
	animplayercharacter.play("death")
	collision_shape.disabled = true
	call_deferred("_spawnexp")
	player._applykillerrush()
	var effect = deatheffect.instantiate()
	add_child(effect)
	effect.global_position = global_position
	deathtimer.start()

func _spawnexp():
	var expamount= expscene.instantiate()
	expamount.global_position = global_position
	expamount.amount = expvalue
	get_tree().current_scene.add_child(expamount)
