extends Node2D

var c_op = 1
var main

func _ready():
	main = get_tree().get_nodes_in_group("main")[0]
	$o4.text = Gamelogic.player_name
	$personaje/nombre.text = "Name/ " + Gamelogic.player_name

func _physics_process(delta):
	if(Gamelogic.estado_actual == Gamelogic.estados.menu_juego):
		if(Input.is_action_just_pressed("tecla_select")): #Cambiar o select
			c_op += 1
			if (c_op > 6):
				c_op = 1
			$c1.global_position = get_node("o"+String(c_op)).get_node("p"+String(c_op)).global_position
		elif (Input.is_action_just_pressed("tecla_s")): #Abajo
			c_op += 1
			if (c_op > 6):
				c_op = 1
			$c1.global_position = get_node("o"+String(c_op)).get_node("p"+String(c_op)).global_position
		elif (Input.is_action_just_pressed("tecla_w")): #Arriba
			c_op -= 1
			if (c_op < 1):
				c_op = 6
			$c1.global_position = get_node("o"+String(c_op)).get_node("p"+String(c_op)).global_position
		elif (Input.is_action_just_pressed("tecla_x")): #Aceptar
			match (c_op):
				1: #Pokedex
					pass
				2: #Pokemon
					$pokemon.visible = true
					$pokemon.cargar_datos()
					Gamelogic.estado_actual = Gamelogic.estados.menu_pokemon
				3: #Mochila
					pass
				4: #Personaje
					Gamelogic.estado_actual = Gamelogic.estados.menu_personaje
					$personaje.visible = true
					$personaje.cargar_personaje()
				5: #Guardar
					guardar_partida()
					var dialogo_4 = []
					dialogo_4.append("Game Saved!")
					Gamelogic.generar_texto_char(dialogo_4)
					visible = false
					Gamelogic.estado_actual = Gamelogic.estados.juego
				6:
					pass
		elif (Input.is_action_just_pressed("tecla_z")): #Cancelar
			visible = false
			Gamelogic.estado_actual = Gamelogic.estados.juego

func guardar_partida():
	
	var path = Directory.new()
	
	if(!path.dir_exists("res://Data/Maps")):
		path.make_dir("res://Data/Maps")
	
	var file = File.new()
	file.open("res://Data/Save/save.dat", File.WRITE)
	
	var data = Savedata.gamedata
	
	data.nombre = Gamelogic.player_name
	data.dinero = Gamelogic.dinero
	data.tiempo = Gamelogic.tiempo
	data.cant_pkmn = Gamelogic.lista_pokemons.size()
	data.pkmns = Gamelogic.lista_pokemons
	data.mapa = get_tree().get_nodes_in_group("nivel")[0].name
	data.pos_act_x = get_tree().get_nodes_in_group("player")[0].global_position.x
	data.pos_act_y = get_tree().get_nodes_in_group("player")[0].global_position.y
	data.nombre_r = Gamelogic.rival_name
	
	
	
	
	file.store_line(to_json(data))
	
	file.close()
	
	main.check_data_provis()
