extends Node2D



func _ready():
	pass # Replace with function body.

func cargar_personaje():
	$dinero.text = "Money/ " + String(Gamelogic.dinero)

func _physics_process(delta):
	
	if(Gamelogic.estado_actual == Gamelogic.estados.menu_personaje):
		
		var minutos = Gamelogic.tiempo / 60
		var horas = minutos / 60
		
		$tiempo.text = "Time/ " + String(horas) + ":" + String(minutos) + ":" + String(Gamelogic.tiempo % 60)
		

		
		if(Input.is_action_just_pressed("tecla_z")):
			Gamelogic.estado_actual = Gamelogic.estados.menu_juego
			visible = false
			
