extends Control

@onready var uiOne ={
	"money": $Panel/money,
	"resources": $Panel/resources,
	"demands": $Panel/demands,
	"total": $Panel/total,
	"zoomies": $Panel/level_zoom
}

func _process(_delta) -> void:
	uiOne.money.text = str(Global.money) + " dabloons"
	uiOne.resources.text = str(Global.resources) + " lego bricks"
	uiOne.demands.text = "R: " + str(Global.demands["resi"]) + " C: " + str(Global.demands["comm"]) + " I: " + str(Global.demands["indus"])
	uiOne.total.text = str(Global.total["resi"] + Global.total["comm"] + Global.total["indus"]) + " lego sets"
	uiOne.zoomies.text = " zoomies"
