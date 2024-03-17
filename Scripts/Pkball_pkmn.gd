extends StaticBody2D

export (Array) var dialogo_1
export (Array) var dialogo_2
var nombre_pkmn

export (int) var pkmn_num

var instancia_i = 0

func _ready():
	pass # Replace with function body.

func interaccion():
	match(get_tree().get_nodes_in_group("nivel")[0].instancia):
		1:
			Gamelogic.generar_texto_char(dialogo_1.duplicate())
		4:
			var newcard = get_tree().get_nodes_in_group("main")[0].card.instance()
			get_tree().get_nodes_in_group("gui")[0].add_child(newcard)
			newcard.load_pkmn(pkmn_num)
			newcard.nodo_ref = self
			nombre_pkmn = newcard.get_node("txtname").text
		5, 6, 7:
			Gamelogic.generar_texto_char(dialogo_2.duplicate())
		
		
func procesar_seleccion(var si):
	if(si):
		if (instancia_i == 0): #Confirmacion Pkmn
			var p = Pokemon.crear_pokemon(pkmn_num, "", "", 5)
			Gamelogic.lista_pokemons.append(p)
			var dialogo_4 = []
			dialogo_4.append("Do you want to name your " + nombre_pkmn + "?")
			Gamelogic.generar_texto_char(dialogo_4.duplicate())
			var newopc = get_tree().get_nodes_in_group("main")[0].menu_opc.instance()
			get_tree().get_nodes_in_group("gui")[0].add_child(newopc)
			newopc.nodo_ref = self
			instancia_i += 1
			get_tree().get_nodes_in_group("main")[0].ref_mote = p
		elif(instancia_i == 1): #Mote
			Gamelogic.estado_actual =Gamelogic.estados.mote
			var newMote = get_tree().get_nodes_in_group("main")[0].mote.instance()
			newMote.estado = 0
			get_tree().get_nodes_in_group("gui")[0].add_child(newMote)
			get_tree().get_nodes_in_group("nivel")[0].instancia = 6
			get_tree().get_nodes_in_group("nivel")[0].procesar_instancia()
			queue_free()
			
	else:
		if(instancia_i == 0):
			Gamelogic.estado_actual =Gamelogic.estados.juego
			
		if (instancia_i == 1):
			Gamelogic.estado_actual =Gamelogic.estados.juego
			get_tree().get_nodes_in_group("nivel")[0].instancia = 6
			get_tree().get_nodes_in_group("nivel")[0].procesar_instancia()
			queue_free()
		
		

func card_cancel():
	var dialogo_3 = []
	dialogo_3.append("So! You want the POkemon," + nombre_pkmn + "?")
	Gamelogic.generar_texto_char(dialogo_3.duplicate())
	var newopc = get_tree().get_nodes_in_group("main")[0].menu_opc.instance()
	get_tree().get_nodes_in_group("gui")[0].add_child(newopc)
	newopc.nodo_ref = self
