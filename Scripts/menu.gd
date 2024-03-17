extends Node2D

var texto_on = false
var instancia = 1
var opc_i1_act = 0 #0 start, 1 opciones, 2 continuar
var nombre_mote = ""

var opc_i2 = 1

export (Array) var dialogo_1
export (Array) var dialogo_2
export (Array) var dialogo_3
export (Array) var dialogo_4
export (Array) var dialogo_5
export (Array) var dialogo_6
export (Array) var dialogo_7

export (PackedScene) var scn_juego
export (PackedScene) var scn_mote

func _ready():
	delete_provis_data()

func _physics_process(delta):
	if(Gamelogic.estado_actual == Gamelogic.estados.menu_ppal):
		if Input.is_action_just_pressed("tecla_x"):
			match(instancia):
				1:
					pass
				2:
					procesar_instancia()
				3:
					Gamelogic.procesar_texto()
				4:
					Gamelogic.procesar_texto()
				5:
					Gamelogic.procesar_texto()
				6:
					procesar_instancia()
				7:
					Gamelogic.procesar_texto()
				8:
					Gamelogic.procesar_texto()
				9:
					procesar_instancia()
				10:
					Gamelogic.procesar_texto()
				11:
					Gamelogic.procesar_texto()
				12:
					get_node("GUI/12/AnimationPlayer").play("start")
		
		if Input.is_action_just_pressed("tecla_start"):
			match(instancia):
				1:
					var file = File.new()
					if(file.file_exists("res://Data/Save/save.dat")):
						get_node("GUI/2/op3").visible =true
						opc_i2 += 1
					procesar_instancia()
			
		if Input.is_action_just_pressed("tecla_select"):
			match(instancia):
				2:
					opc_i1_act += 1
					if (opc_i1_act > opc_i2): #Si alcanzo el limite de opciones vuelve al primero
						opc_i1_act = 0
					get_node("GUI/2/select").global_position = get_node("GUI/2/" + String(opc_i1_act)).global_position
				6:
					opc_i1_act += 1
					if (opc_i1_act > 2): #Si alcanzo el limite de opciones vuelve al primero
						opc_i1_act = 0
					get_node("GUI/6/select").global_position = get_node("GUI/6/" + String(opc_i1_act)).global_position
				9:
					opc_i1_act += 1
					if (opc_i1_act > 2): #Si alcanzo el limite de opciones vuelve al primero
						opc_i1_act = 0
					get_node("GUI/9/select").global_position = get_node("GUI/9/" + String(opc_i1_act)).global_position
					


func procesar_instancia():
	match(instancia):
		1:
			get_node("GUI/"+String(instancia)).visible = false
			instancia = 2
			get_node("GUI/"+String(instancia)).visible = true
		2:
			if(opc_i1_act == 0):
				var file = File.new()
				var d = Directory.new()
				if(file.file_exists("res://Data/Save/save.dat")):
					d = Directory.new()
					d.remove("res://Data/Save/save.dat")
				if(file.file_exists("res://Data/Save/rival.dat")):
					d = Directory.new()
					d.remove("res://Data/Save/rival.dat")
				if(d.dir_exists("res://Data/Maps")):
					d.open("res://Data/Maps")
					d.list_dir_begin()
					
					while true:
						file = d.get_next()
						if file == "":
							break
						elif not file.begins_with("."):
							d.remove(file)
					d.list_dir_end()
				
				get_node("GUI/"+String(instancia)).visible = false
				instancia = 3
				get_node("GUI/"+String(instancia)).visible = true
				Gamelogic.generar_texto_char(dialogo_1.duplicate())
			elif(opc_i1_act == 1): #Menu de opciones
				pass
			else: #Cargar partida
				cargar_partida()
		3:
			get_node("GUI/"+String(instancia)).visible = false
			instancia = 4
			get_node("GUI/"+String(instancia)).visible = true
			Gamelogic.generar_texto_char(dialogo_2.duplicate())
		4:
			get_node("GUI/"+String(instancia)).visible = false
			instancia = 5
			get_node("GUI/"+String(instancia)).visible = true
			Gamelogic.generar_texto_char(dialogo_3.duplicate())
		5:
			get_node("GUI/"+String(instancia)).visible = false
			instancia = 6
			get_node("GUI/"+String(instancia)).visible = true
			opc_i1_act = 0
		6:
			if (opc_i1_act == 0): #Abro menu mote
				get_node("GUI/"+String(instancia)).visible = false
				var newMote = scn_mote.instance()
				newMote.estado = 0
				get_node("GUI").add_child(newMote)
				Gamelogic.estado_actual = Gamelogic.estados.mote
			else:
				get_node("GUI/"+String(instancia)).visible = false
				Gamelogic.player_name = get_node("GUI/"+ String(instancia)+ "/"+ "op" + String(opc_i1_act+1)).text
				instancia = 7
				get_node("GUI/"+String(instancia)).visible = true
				dialogo_4[0] += " " + Gamelogic.player_name
				Gamelogic.generar_texto_char(dialogo_4.duplicate())
		7:
			get_node("GUI/"+String(instancia)).visible = false
			instancia = 8
			get_node("GUI/"+String(instancia)).visible = true
			Gamelogic.generar_texto_char(dialogo_5.duplicate())
		8:
			get_node("GUI/"+String(instancia)).visible = false
			instancia = 9
			get_node("GUI/"+String(instancia)).visible = true
			opc_i1_act = 0
		9:
			if (opc_i1_act == 0): #Abro menu mote
				get_node("GUI/"+String(instancia)).visible = false
				var newMote = scn_mote.instance()
				newMote.estado = 0
				get_node("GUI").add_child(newMote)
				Gamelogic.estado_actual = Gamelogic.estados.mote
			else:
				get_node("GUI/"+String(instancia)).visible = false
				Gamelogic.rival_name = get_node("GUI/"+ String(instancia)+ "/"+ "op" + String(opc_i1_act+1)).text
				instancia = 10
				get_node("GUI/"+String(instancia)).visible = true
				dialogo_6[1] += " " + Gamelogic.rival_name
				Gamelogic.generar_texto_char(dialogo_6.duplicate())
				opc_i1_act = 0
		10:
			get_node("GUI/"+String(instancia)).visible = false
			instancia = 11
			get_node("GUI/"+String(instancia)).visible = true
			dialogo_7[0] = Gamelogic.player_name
			Gamelogic.generar_texto_char(dialogo_7.duplicate())
		11:
			get_node("GUI/"+String(instancia)).visible = false
			instancia = 12
			get_node("GUI/"+String(instancia)).visible = true
			get_node("GUI/12/AnimationPlayer").play("start")
			Gamelogic.estado_actual = Gamelogic.estados.juego
		


func _on_tmp_timeout():
	
	if (Gamelogic.txt_actual != Gamelogic.texto.size()):
		
		var oracion = Gamelogic.texto[Gamelogic.txt_actual]
		
		if (oracion != get_tree().get_nodes_in_group("gui")[0].get_node("txt").text):
			
			get_tree().get_nodes_in_group("gui")[0].get_node("txt").text += oracion[Gamelogic.contador_letra]
			
			Gamelogic.contador_letra += 1
			
		else:
			
			Gamelogic.contador_letra = 0
			
	else:
		
		Gamelogic.procesar_texto()
	

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene_to(scn_juego)

func procesar_name():
	if (instancia == 6):
		Gamelogic.player_name = nombre_mote
		instancia += 1
		instancia = 7
		get_node("GUI/"+String(instancia)).visible = true
		dialogo_4[0] += " " + Gamelogic.player_name
		Gamelogic.generar_texto_char(dialogo_4.duplicate())
	elif (instancia == 9):
		Gamelogic.rival_name = nombre_mote
		instancia = 10
		get_node("GUI/"+String(instancia)).visible = true
		dialogo_6[1] += " " + Gamelogic.rival_name
		Gamelogic.generar_texto_char(dialogo_6.duplicate())
		opc_i1_act = 0


func cargar_partida():
	var file = File.new()
	if(!file.file_exists("res://Data/Save/save.dat")):
		return
	file.open("res://Data/Save/save.dat", File.READ)
	
	var data = Savedata.gamedata
	
	if (!file.eof_reached()):
		data = parse_json(file.get_line())
	
	Gamelogic.player_name = data.nombre 
	Gamelogic.dinero = data.dinero
	Gamelogic.tiempo = int(data.tiempo) 
	#data.cant_pkmn 
	Gamelogic.lista_pokemons = data.pkmns 
	Gamelogic.rival_name = data.nombre_r 
	Gamelogic.load_level = data.mapa 
	Gamelogic.load_position = Vector2(data.pos_act_x, data.pos_act_y)
	
	file.close()
	
	Gamelogic.estado_actual = Gamelogic.estados.juego
	Gamelogic.load_game = true
	get_tree().change_scene_to(scn_juego)

func delete_provis_data(): #Elimino datos provisorios de partida anterior
	var file = File.new()
	var d = Directory.new()
	if(d.dir_exists("res://Data/Maps/provis")):
		d.open("res://Data/Maps/provis")
		d.list_dir_begin()
		while true:
			file = d.get_next()
			if file == "":
				break
			elif not file.begins_with("."):
				d.remove(file)
	d.list_dir_end()
	
	file = File.new()
	if(file.file_exists("res://Data/Rivales/provis/rival.dat")):
		d = Directory.new()
		d.remove("res://Data/Rivales/provis/rival.dat")
