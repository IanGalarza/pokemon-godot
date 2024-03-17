extends Node2D

export (PackedScene) var profOAK

var instancia = 1
var main

func _ready():
	main = get_tree().get_nodes_in_group("main")[0]
	main.try_load_lvl_instance("4", self)
	
	if (instancia == 2):
		procesar_instancia()
	
	
	elif(instancia > 2):
		var Profoak = profOAK.instance()
		Profoak.global_position = get_node("OAK_T").global_position
		add_child(Profoak)
		if(instancia > 5):
			if(Gamelogic.lista_pokemons[0].numero == 4):
				$Pkball.queue_free()
				$Pkball2.queue_free()
			elif(Gamelogic.lista_pokemons[0].numero == 7):
				$Pkball3.queue_free()
				$Pkball2.queue_free()
			elif(Gamelogic.lista_pokemons[0].numero == 1):
				$Pkball3.queue_free()
				$Pkball.queue_free()
	
	print(instancia)

func procesar_instancia():
	match(instancia):
		1:
			pass
		2: #Entro el PROF. Oak
			var Profoak = profOAK.instance()
			Profoak.global_position = get_node("spawn_OAK").global_position
			add_child(Profoak)
			
			var cantidad = 1
			while(cantidad < 9):
				Profoak.add_path(0)
				cantidad += 1
			
			
			yield(get_tree().create_timer(0.5),"timeout")
			
			var jugador = get_tree().get_nodes_in_group("player")[0]
			jugador.objetivo = $OAK_T.global_position
			jugador.objetivo += Vector2(0, 16)
			jugador.create_path()
			jugador.path.remove(0)
			
			instancia += 1
		3: #Caminando
			pass
		4: # Dialogo prof.oak 
			pass
		5: #Eleccion PKMN
			pass
		6:  # Rival elije pkmn #Me dirijo al rival
			var rival = get_tree().get_nodes_in_group("rival")[0]
			rival.add_path(0)
			rival.add_path(3)
			rival.add_path(3)
			if(Gamelogic.lista_pokemons[0].numero == 4):
				rival.add_path(3)
			elif(Gamelogic.lista_pokemons[0].numero == 7):
				rival.add_path(3)
				rival.add_path(3)
			elif(Gamelogic.lista_pokemons[0].numero == 1):
				pass
				
			rival.path.remove(0)
			yield(get_tree().create_timer(1),"timeout")
			
			rival.mirar(1)
			
			Gamelogic.transicion = true
			
			
			
		7: #Borrado de pokeball y guardado de datos
			var rival = get_tree().get_nodes_in_group("rival")[0]
			
			if(Gamelogic.lista_pokemons[0].numero == 4): #Charmander
				$Pkball2.queue_free()
				rival.save_pkm(7)
			#	p = Pokemon.crear_pokemon(7, "", Gamelogic.rival_name, 5)
			#	rival.lista_pokemons.append(p)
			elif(Gamelogic.lista_pokemons[0].numero == 7): #Squirtle
				$Pkball3.queue_free()
				rival.save_pkm(1)
			#	p = Pokemon.crear_pokemon(1, "", Gamelogic.rival_name, 5)
			#	rival.lista_pokemons.append(p)
			elif(Gamelogic.lista_pokemons[0].numero == 1): #Bulbasaur
				$Pkball.queue_free()
				rival.save_pkm(4)
			#	p = Pokemon.crear_pokemon(4, "", Gamelogic.rival_name, 5)
			#	rival.lista_pokemons.append(p)
			Gamelogic.transicion = false
			Gamelogic.generar_texto_char(rival.dialogo_3.duplicate())
			instancia += 1
		8: #Dialogo 2 rival
			pass
		9: #Se retira rival
			pass
		10: #Navegacion libre
			pass
			
	main.save_data(4, self)
	


func _on_Evitar_Salida_body_entered(body):
	if(body.is_in_group("player") and instancia == 4):
		body.objetivo = body.global_position
		body.objetivo -= Vector2(0, 8)
		body.create_path()
		body.path.remove(0)
		get_tree().get_nodes_in_group("oak")[0]._interaccion(0 , get_tree().get_nodes_in_group("oak")[0].dialogo_4)
	elif(instancia == 8): #Previa a pelea con rival
		var rival = get_tree().get_nodes_in_group("rival")[0]
		rival.objetivo = get_tree().get_nodes_in_group("player")[0].global_position
		rival.objetivo += Vector2(0,-16)
		rival.create_path()
		rival.path.remove(0)
		Gamelogic.estado_actual = Gamelogic.estados.battle
		


