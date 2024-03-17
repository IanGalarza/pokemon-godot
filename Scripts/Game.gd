extends Node2D

export(PackedScene) var card
export(PackedScene) var mote
export(PackedScene) var menu_opc

export (PackedScene) var player
export (PackedScene) var nivel1
export (PackedScene) var nivel2
export (PackedScene) var nivel3
export (PackedScene) var nivel4
export (PackedScene) var nivel5


var nivel_actual = 1
var cas_n
var cargando_escena = false
var texto_on = false
var nombre_mote = ""
var ref_mote

func _ready():
	randomize()
	if(!Gamelogic.load_game):
		spawn_lvl_player(nivel1, 0)
	else:
		load_spawn_player(Gamelogic.load_level, Gamelogic.load_position)
		Gamelogic.load_game = false


func check_door(casillero):
	
	cargando_escena = true
	
	$fade.play("fadeout")
	
	cas_n = casillero
	

func spawn_lvl_player(lvl, n_spawn):
	var newLvl = lvl.instance()
	add_child(newLvl)
	var newPlayer = player.instance()
	$game.add_child(newPlayer)
	newPlayer.global_position = get_tree().get_nodes_in_group("spawn")[n_spawn].global_position

func load_spawn_player(lvl, posicion):
	var n = load("res://Scenes/" + lvl + ".tscn")
	var newLvl = n.instance()
	add_child(newLvl)
	var newPlayer = player.instance()
	$game.add_child(newPlayer)
	newPlayer.global_position = posicion
	nivel_actual = int(lvl[5])
	
func _on_fade_animation_finished(anim_name):
	
	if(anim_name == "fadeout"):
		
		$fade.play("fadein")
		
		get_tree().get_nodes_in_group("player")[0].queue_free()
		
		get_tree().get_nodes_in_group("nivel")[0].free()
		
		match(nivel_actual):
			1:
				nivel_actual = 2
				
				spawn_lvl_player(nivel2, 0)
			2:
				if(cas_n == Vector2(3, -2)):
					
					nivel_actual = 1
					
					spawn_lvl_player(nivel1, 1)
					
				elif(cas_n == Vector2(-1,4) or cas_n == Vector2(-2, 4)):
					
					nivel_actual = 3
					
					spawn_lvl_player(nivel3, 0)
			3:
				if(cas_n == Vector2(-1, -1)): #casa player
					
					nivel_actual = 2
					
					spawn_lvl_player(nivel2,1)
					
				elif(cas_n == Vector2(7, -1)): #casa enemigo
					
					nivel_actual = 5
					
					spawn_lvl_player(nivel5, 0)
					
				elif(cas_n == Vector2(6, 5)): #lab oak
					
					nivel_actual = 4
					
					spawn_lvl_player(nivel4, 0)
					
			4:
				if (cas_n == Vector2(2, 8) or cas_n == Vector2(3,8)):
					
					nivel_actual = 3
					
					spawn_lvl_player(nivel3, 2)
					
			5:
				if (cas_n == Vector2(-1, 4) or cas_n == Vector2(-2, 4)):
					
					nivel_actual = 3
					
					spawn_lvl_player(nivel3, 1)
					
				
		cargando_escena = false

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
		
	
func procesar_name():
	Gamelogic.estado_actual = Gamelogic.estados.juego
	ref_mote.nombre = nombre_mote
	print(Gamelogic.lista_pokemons[0].nombre)
	


func _on_tmr_timeout():
	Gamelogic.tiempo += 1

func iniciar_batalla(rival):
	$GUI/mnu_batalla.cargar_datos(rival)
	$GUI/battle_load/AnimationPlayer.play("in")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "in"):
		start_battle()
		$GUI/battle_load/AnimationPlayer.play("out")
	elif(anim_name == "out"):
		pass

func try_load_lvl_instance(num, obj_niv):
	num = String(num)
	var file = File.new()
	if(file.file_exists("res://Data/Maps/provis/" + num + ".dat")):
		file.open("res://Data/Maps/provis/" + num + ".dat", File.READ)
		if(!file.eof_reached()):
			obj_niv.instancia = int(to_json(file.get_line()))
		file.close()
	elif(file.file_exists("res://Data/Maps/" + num + ".dat")):
		file.open("res://Data/Maps/" + num + ".dat", File.READ)
		if(!file.eof_reached()):
			obj_niv.instancia = int(to_json(file.get_line()))
		file.close()
		
func save_data(num, obj_niv):
	
	num = String(num)
	
	var file = File.new()
	
	file.open("res://Data/Maps/provis/" + num + ".dat", File.WRITE)
	
	file.store_line(to_json(obj_niv.instancia))
	
	file.close()

func check_data_provis():
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
				d.rename("res://Data/Maps/provis/" + file,"res://Data/Maps/" + file)
	d.list_dir_end()
	
	#Rivales
	if(d.dir_exists("res://Data/Rivales/provis")):
		d.open("res://Data/Rivales/provis")
		d.list_dir_begin()
		
		while true:
			file = d.get_next()
			if file == "":
				break
			elif not file.begins_with("."):
				d.rename("res://Data/Rivales/provis/" + file,"res://Data/Save/" + file)
	d.list_dir_end()


func start_battle():
	Gamelogic.estado_actual = Gamelogic.estados.battlestarted
	$GUI/bkg_txt.visible = true
	$GUI/mnu_batalla.visible = true

func exit_battle():
	$GUI/bkg_txt.visible = false
	$GUI/mnu_batalla.visible = false
	



