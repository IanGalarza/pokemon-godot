extends Node2D

var c_op = 1

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if(Gamelogic.estado_actual == Gamelogic.estados.menu_pokemon and Gamelogic.lista_pokemons.size() > 0):
		if(Input.is_action_just_pressed("tecla_select")): #Cambiar o select
			c_op += 1
			if (c_op > Gamelogic.lista_pokemons.size()):
				c_op = 1
			$c2.global_position = get_node("P"+String(c_op)).get_node("p"+String(c_op)).global_position
		elif (Input.is_action_just_pressed("tecla_s")): #Abajo
			c_op += 1
			if (c_op > Gamelogic.lista_pokemons.size()):
				c_op = 1
			$c2.global_position = get_node("P"+String(c_op)).get_node("p"+String(c_op)).global_position
		elif (Input.is_action_just_pressed("tecla_w")): #Arriba
			c_op -= 1
			if (c_op < 1):
				c_op = Gamelogic.lista_pokemons.size()
			$c2.global_position = get_node("P"+String(c_op)).get_node("p"+String(c_op)).global_position
		elif (Input.is_action_just_pressed("tecla_x")): #Aceptar
			pass
		elif (Input.is_action_just_pressed("tecla_z")): #Cancelar
			visible = false
			Gamelogic.estado_actual = Gamelogic.estados.menu_juego
			
func cargar_datos():
	for i in Gamelogic.lista_pokemons.size():
		get_node("P"+String(i+1)).visible = true
		get_node("P"+String(i+1)).text = Gamelogic.lista_pokemons[i].nombre
		get_node("P"+String(i+1)).get_node("ProgressBar").value = int(Gamelogic.lista_pokemons[i].hp)* 100 / int(Gamelogic.lista_pokemons[i].hp_max)
		get_node("P"+String(i+1)).get_node("VIDA").text = Gamelogic.lista_pokemons[i].hp + " / " + Gamelogic.lista_pokemons[i].hp_max
		get_node("P"+String(i+1)).get_node("LN").text = "LN" + String(Gamelogic.lista_pokemons[i].nivel)
		get_node("P"+String(i+1)).get_node("A").play(Gamelogic.lista_pokemons[i].tipo.to_lower())
