extends Node2D

export(Array) var objetos

func _ready():
	for objeto in objetos:
		var newItem = objeto.instance()
		add_child(newItem)
		
