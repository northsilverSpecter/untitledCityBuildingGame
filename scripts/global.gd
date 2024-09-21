extends Node3D

var money = 500
var resources = 1000
var population = 0
var demands = { #the default is 5 as in no demands
	"resi": 5, #less than 5 means unnessessary stuff
	"comm": 5, #more than 5 means must-have stuff
	"indus": 5 #they change based on amount of 3 types
}
var total = { #it starts at zero at first in load
	"resi": 0, #when the player build something,
	"comm": 0, #It is changed in one of theses counters
	"indus": 0 #that is only possible using signals
} #or some method to scan amount of node buildings

var new_game = true

func _ready() -> void:
	print(money)
	print(resources)
	print(demands.resi)
	print(demands.comm)
	print(demands.indus)
	print(total.resi + total.comm + total.indus)
	#above this line is basically combined total amount
