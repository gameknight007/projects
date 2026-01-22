extends Panel
@export var powerups : PackedScene
@onready var h_box_container: HBoxContainer = $panel/HBoxContainer
@onready var player: CharacterBody2D = $"../../.."

var collectedupgrades = []
var upgradeoptions = []

func _additems():
	var options = 0
	var maxoptions = 3 
	while  options < maxoptions:
		var optionchoice = powerups.instantiate()
		optionchoice.item = _getrandomitem()
		h_box_container.add_child(optionchoice)
		options += 1


func _getrandomitem():
	var dblist = []
	for i in Upgradedatabase.UPGRADES :
		if i in collectedupgrades:
			pass
		elif  i in upgradeoptions:
			pass
		elif Upgradedatabase.UPGRADES[i]["type"] == " consumable" :
			pass
		elif Upgradedatabase.UPGRADES[i]["requirement"].size() > 0 :
			for n in Upgradedatabase.UPGRADES[i]["requirement"]:
				if not n  in collectedupgrades:
					pass
				else:
					dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0 :
		var randomitem = dblist.pick_random()
		upgradeoptions.append(randomitem)
		return randomitem
	else:
		return null
	
