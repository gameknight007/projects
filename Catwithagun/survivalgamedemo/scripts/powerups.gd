extends Control

@onready var itemname: Label = $Panel/VBoxContainer/itemname
@onready var itemdescription: Label = $Panel/VBoxContainer/itemdescription

@onready var player = get_tree().get_first_node_in_group("PLAYER")
@onready var currentscene = get_tree().current_scene


var item = null
signal upgradeselected(upgrade)

func _ready():
	upgradeselected.connect(Callable(player,"_applypowerup"))
	if item == null :
		item = "milk"
		pass
	itemname.text = Upgradedatabase.UPGRADES[item]["displayname"]
	itemdescription.text = Upgradedatabase.UPGRADES[item]["description"]

func _on_button_pressed():
	emit_signal("upgradeselected",item)
