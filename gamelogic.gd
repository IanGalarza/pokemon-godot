extends Node


var txt_actual = 0
var texto = []
var oracion_actual = ""
var contador_letra = 0
var mapa = false
var mapa_Abierto = false
var cas_n
enum estados{menu_ppal,juego,mote,menu_juego, menu_pokemon, card, menu_personaje, wait, battle, battlestarted}
var estado_actual = estados.menu_ppal
var player_name = ""
var rival_name = ""
var pise_pasto = false
var transicion = false

var dinero = 0
var tiempo = 0

var load_game = false
var load_level = 1
var load_position = Vector2()

var lista_pokemons = []

func generar_texto(num):
	
	texto.clear()
	get_tree().get_nodes_in_group("gui")[0].get_node("bkg_txt").visible = true
	get_tree().get_nodes_in_group("gui")[0].get_node("txt").visible = true
	get_tree().get_nodes_in_group("main")[0].texto_on = true
	get_tree().get_nodes_in_group("gui")[0].get_node("tmp").start()
	cas_n = get_tree().get_nodes_in_group("tile")[0].world_to_map(get_tree().get_nodes_in_group("player")[0].get_node("palo/pos").global_position)
	match(num):
		285: #texto consola
			texto.append(player_name + " is playing the SNES!")
			texto.append("...Okay!")
			texto.append("It's time to go!")
		284: #texto TV
			texto.append("There's a movie on TV. Four boys...")
			texto.append("are walking on railroad tracks.")
			texto.append("I better go too.")
		290: #texto PC
			texto.append("There's a game available to play!")
			texto.append("Yakuza: like a dragon...?")
			texto.append("What's that?")
		247: #texto estantes casa ash
			texto.append("Crammed full of POKEMON books!")
		4: #texto cartel casa ash
			texto.append(player_name + "'s house")
		318: #Texto cartel casa enemigo
			texto.append(rival_name + "'s house")
		319: #Texto cartel pueblo paleta
			texto.append("PALLET TOWN")
			texto.append("Shades of your journey await!")
		320: #Texto cartel laboratorio oak
			texto.append("OAK POKEMON RESEARCH LAB")
		5: #texto Mapa
			texto.append("A TOWN MAP")
			mapa = true
		6: #texto PC oak
			texto.append("There's an e-mail message here!")
			texto.append("...")
			texto.append("Calling all POKEMON trainers!")
			texto.append("The elite Trainers of POKEMON LEAGUE")
			texto.append("are ready to take on all comers!")
			texto.append("Bring your best pokemon and see...")
			texto.append("how you rate as a trainer!")
			texto.append("POKEMON LEAGUE HQ INDIGO PLATEAU")
			texto.append("PS: PROF.OAK, please visit us!")
		7: #texto manuscrito
			match(get_tree().get_nodes_in_group("main")[0].nivel_actual):
				4: #lab oak
					if cas_n == Vector2(2, -4):
						texto.append("Push START to open the menu!") 
					if cas_n == Vector2(3, -4):
						texto.append("The SAVE option is on the MENU") 
			
	txt_actual = 0
	oracion_actual = ""
	

func generar_texto_char(dial):
	
	texto.clear()
	
	get_tree().get_nodes_in_group("gui")[0].get_node("bkg_txt").visible = true
	
	get_tree().get_nodes_in_group("gui")[0].get_node("txt").visible = true
	
	get_tree().get_nodes_in_group("main")[0].texto_on = true
	
	get_tree().get_nodes_in_group("gui")[0].get_node("tmp").start()
	
	texto = dial
	
	txt_actual = 0
	
	oracion_actual = ""
	

func procesar_texto():
	if (txt_actual == texto.size()):
		
		get_tree().get_nodes_in_group("main")[0].texto_on = false
		
		get_tree().get_nodes_in_group("gui")[0].get_node("bkg_txt").visible = false
		
		get_tree().get_nodes_in_group("gui")[0].get_node("txt").visible = false
		
		get_tree().get_nodes_in_group("gui")[0].get_node("tmp").stop()
		
		if (mapa):
			mapa = false
			abrirMapa(true)
		
		if(estado_actual == estados.menu_ppal):
			get_tree().get_nodes_in_group("main")[0].procesar_instancia()
		
	else:
		if(texto[txt_actual] == get_tree().get_nodes_in_group("gui")[0].get_node("txt").text):
			
			txt_actual += 1
			
			get_tree().get_nodes_in_group("gui")[0].get_node("txt").text = ""
			
		else:
			
			get_tree().get_nodes_in_group("gui")[0].get_node("txt").text = texto[txt_actual]


	
func _ready():
	pass # Replace with function body.

func abrirMapa(var vis):
	mapa_Abierto = vis
	get_tree().get_nodes_in_group("mapa")[0].visible = vis
	
func reemplazar_nombre(dialogo):
	if(dialogo.size() > 0):
		for i in dialogo.size():
			if("player_name" in dialogo[i]):
				dialogo[i] = dialogo[i].replace("player_name", player_name)
			if("rival_name" in dialogo[i]):
				dialogo[i]= dialogo[i].replace("rival_name", rival_name)
	


