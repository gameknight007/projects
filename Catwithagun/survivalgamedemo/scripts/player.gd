extends CharacterBody2D

@export var speed = 350.0
@export var maxhealth = 9.0
@export var level : int = 1
@onready var gun: Node2D = $gun
@onready var healthbar: ProgressBar = $CanvasLayer/healthbar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var expbar: ProgressBar = $CanvasLayer/HUD/HBoxContainer/expbar
@onready var levelnumber: Label = $CanvasLayer/HUD/HBoxContainer/levelnumber
@onready var upgradespanel: Panel = $CanvasLayer/HUD/upgradespanel
@onready var h_box_container: HBoxContainer = $CanvasLayer/HUD/upgradespanel/panel/HBoxContainer
@onready var invsiblility: Timer = $invsiblility
@onready var collision_shapehurtbox: CollisionShape2D = $hurtbox/CollisionShape2D
@onready var hitflashplayer: AnimationPlayer = $hitflashplayer
@onready var standardtimer: Timer = $standardtimer
@onready var skeleton_2d: Skeleton2D = $Skeleton2D
@onready var killerrushtimer: Timer = $killerrushtimer
@onready var abilityactive: AudioStreamPlayer2D = $abilityactive
@onready var gothitsound : AudioStreamPlayer = $gothit

var gundirection = Vector2.ZERO
var health = 0.0
var damage_rate = 5.0
var maxhearts = 9.0
var hearts = 0.0
var exp_points = 0
var total_exp = 0
var req_exp = _get_requiredexp(level + 1)
var gothit = false
var knockbackforce = 0

var killerrush = false
var alleycatgrit = false

var tempspeed = 0
var tempdamage = 0
var tempfirerate = 0.0
	
signal health_depleted
signal healthchanged(playerhearts)

func _ready() -> void:
	collision_shapehurtbox.disabled = false
	upgradespanel.modulate.a = 0
	health = maxhealth
	healthbar.max_value = maxhealth
	hearts = maxhearts
	emit_signal("healthchanged",maxhearts)

func _physics_process(delta: float) -> void:
	#healthbar.value = health
	expbar.value = exp_points
	expbar.max_value = req_exp
	levelnumber.text = "Level : " + str(level)
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * speed
	if gothit :
		velocity += knockbackforce
		gothit = false
	if direction.x == 0 and direction.y == 0 :
		animation_player.play("idle")
	else:
		animation_player.play("move")
	if gundirection.x > 0 :
		skeleton_2d.scale.x = 1
	else:
		skeleton_2d.scale.x = -1
	move_and_slide()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	hitflashplayer.play("hit")
	var knock = body.global_position.direction_to(global_position)
	knockbackforce = knock.normalized() * 900
	call_deferred("take_damage")
	gothit = true
	gothitsound.play()

func take_damage():
	invsiblility.start()
	collision_shapehurtbox.disabled = true
	hearts -= 1
	emit_signal("healthchanged",hearts)
	if hearts < 2 :
		if alleycatgrit :
			pass
	else:
		pass
	if hearts <= 0 :
		health_depleted.emit()

func _addexp(value):
	total_exp += value
	exp_points += value
	while exp_points >= req_exp :
		exp_points -= req_exp
		level_up()

func _get_requiredexp(level):
	return round(pow(level,1.8) + level * 4 )

func level_up():
	level += 1
	req_exp = _get_requiredexp(level+1)
	_showitem(upgradespanel)
	upgradespanel._additems()
	Engine.time_scale = 0.0

func _applypowerup(itemname):
	match itemname :
		"milk" :
			if hearts < maxhearts :
				hearts += 1
				emit_signal("healthchanged",hearts)
			speed += (speed * 5)/100
		"milkjug":
			if hearts < maxhearts :
				hearts += 2
				emit_signal("healthchanged",hearts)
			speed += (speed * 5)/100
		"runningboots" :
			if speed < 1000.0 :
				speed += ((speed * 10)/100)
		"feline fury":
			if gun.firerate < 1.3 :
				gun.firerate += (gun.firerate * 15 /100)
			speed += (speed *5/100)
		"killerrush":
			killerrush = true
		"explosiverounds":
			if gun.damage < 50 :
				gun.damage += (gun.damage * 25 / 100)
			gun.firerate -= (gun.firerate * 5)/100
			gun.bulletsize += (gun.bulletsize * 25 /100)
		"doublebarrage" :
			gun.bulletcount += 1
		"triplebarrage":
			gun.bulletcount += 1
			gun.damage -= (gun.damage * 10)/100
		"lightbullets":
			gun.bulletrange += (gun.bulletrange * 25)/100
			gun.bulletspeed += (gun.bulletspeed * 25)/100
		"alleycatgrit":
			alleycatgrit = true
		"":
			return
	_clearitems(itemname)
	Engine.time_scale = 1.0
	_hideitem(upgradespanel)

func _clearitems(item):
	if h_box_container == null :
		return
	var items : Array = h_box_container.get_children()
	for i in items :
		i.queue_free()
	upgradespanel.upgradeoptions.clear()
	upgradespanel.collectedupgrades.append(item)

func _on_invsiblility_timeout() -> void:
	collision_shapehurtbox.disabled = false

func _applykillerrush():
	if not killerrushtimer.is_stopped():
		return
	if killerrush:
		abilityactive.play()
		hitflashplayer.play("killerrush")
		tempspeed = speed
		tempdamage = gun.damage
		tempfirerate = gun.firerate
		speed += (speed *15)/100
		gun.damage += (gun.damage *15)/100
		gun.firerate += ( gun.firerate *15)/100
		killerrushtimer.start()

func _on_killerrushtimer_timeout() -> void:
	speed = tempspeed
	gun.damage = tempdamage
	gun.firerate = tempfirerate

func _showitem(item):
	var tween = get_tree().create_tween()
	tween.tween_property(item,"modulate:a",100,0.5).set_ease(Tween.EASE_IN)

func _hideitem(item):
	var tween = get_tree().create_tween()
	tween.tween_property(item,"modulate:a",0,0.5).set_ease(Tween.EASE_OUT)
