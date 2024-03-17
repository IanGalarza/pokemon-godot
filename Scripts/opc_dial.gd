extends Node2D

var si = true
var nodo_ref #nodo que llamo a este dialogo

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("tecla_select"):
		si = !si
		if(si):
			$cursor.global_position = $si1.global_position
		else:
			$cursor.global_position = $si2.global_position
			
	if Input.is_action_just_pressed("tecla_w"):
		si = true
		$cursor.global_position = $si1.global_position
		
	if Input.is_action_just_pressed("tecla_s"):
		si = false
		$cursor.global_position = $si2.global_position
	
	if Input.is_action_just_pressed("tecla_x"):
		if(Gamelogic.txt_actual == Gamelogic.texto.size()):
			nodo_ref.procesar_seleccion(si)
			queue_free()
		
	
	
