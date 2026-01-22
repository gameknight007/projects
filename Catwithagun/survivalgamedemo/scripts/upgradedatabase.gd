extends Node

const UPGRADES = {
	"milk": {
		#"icon" : HEALICON,
		"displayname" : "GLASS OF MILK",
		"description" : "restore one heart and increase speed by 5%",
		"requirement" : [],
		"level" : "level : 1",
		"type" : "consumable"
		},
	"milkjug" :{
		"displayname" : "JUG OF MILK",
		"description" : "restore two heart and increase speed by 5%",
		"requirement" : ["milk"],
		"level" : "level : 2",
		"type" : "consumable"
	},
	"feline fury": {
		#"icon" : FIRERATEICON,
		"displayname" : "FELINE FURY",
		"description" : "increase firerate by 15% and speed by 5%",
		"requirement" : [],
		"level" : "level : 1",
		"type" : "powerup"
	},
	"runningboots": {
		#"icon" : SPEEDICON,
		"displayname" : "RUNNING BOOTS",
		"description" : "increase speed by 10%",
		"requirement" : [],
		"level" : "level : 1",
		"type" : "powerup"
	},
	"explosiverounds":{
		#"icon" : DAMAGEICON,
		"displayname" : "FUR-OCIOUS FIRE",
		"description" : "increase damage by 25% ,bullet size by 25% and firerate reduced by 5%",
		"requirement" : [],
		"level" : "level : 1",
		"type" : "powerup"
	},
	"doublebarrage":{
		"displayname" : "FURBALL BARRAGE",
		"description" : "shoots one additional bullet",
		"requirement" : [],
		"level" : "level : 1",
		"type" : "powerup"
		},
	"triplebarrage":{
		"displayname" : "FURBALL FRENZY",
		"description" : "shoots thee bullets in total and damage is reduced by 10%",
		"requirement" : ["doublebarrage"],
		"level" : "level : 2",
		"type" : "powerup"
		},
	"killerrush":{
		"displayname" : "FELINE RAMPAGE",
		"description" : "on killng a rat , speed ,firerate and damage increased by 15% for 3 seconds",
		"requirement" : ["feline fury"],
		"level" : "level : 2",
		"type" : "powerup"
	},
	"lightbullets":{
		"displayname" : "LIGHT CATNIPS",
		"description" : "bullet speed increased by 25% and travel distance by 25%",
		"requirement" : [],
		"level" : "level : 1",
		"type" : "powerup"
	},
	"alleycatgrit":{
		"displayname" : "ALLEY CATS GRIT",
		"description" : "if only one life left,15% increase in damage and speed ",
		"requirement" : [],
		"level" : "level : 1",
		"type" : "powerup"
	}
	
}
