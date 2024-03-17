extends KinematicBody2D

var vel_actual = Vector2()
var vel_desp = 16
var main
var pos_siguiente = Vector2()

var objetivo = Vector2()
var path = []
var nav = Navigation2D

func _ready():
	if(get_tree().get_nodes_in_group("nav").size() > 0):
		nav = get_tree().get_nodes_in_group("nav")[0]
	main = get_tree().get_nodes_in_group("main")[0]
	$palo/RayCast2D.add_exception(self)
	
func _physics_process(delta):
	if main.cargando_escena == false and main.texto_on == false and !Gamelogic.mapa_Abierto and Gamelogic.estado_actual == Gamelogic.estados.juego:
		
		if !$AnimationPlayer.is_playing():
			
			if(path.size() == 0):
				
				
				pos_siguiente = global_position
				
				if Input.is_action_just_pressed("tecla_x"):
					
					interactuar_tile() #Vemos si hay un tile
					procesar_raycast() #Vemos si hay otro tipo de objeto
					
				if Input.is_action_pressed("tecla_w"):
					
					pos_siguiente.y -= vel_desp
					
					$palo.rotation_degrees = 0
					
					vel_actual.y = -vel_desp*delta/$AnimationPlayer.get_animation("walk_up").length
					
					$AnimationPlayer.play("walk_up")
					
				elif Input.is_action_pressed("tecla_s"):
					
					pos_siguiente.y += vel_desp
					
					$palo.rotation_degrees = 180
					
					vel_actual.y = vel_desp*delta/$AnimationPlayer.get_animation("walk_down").length
					
					$AnimationPlayer.play("walk_down")
					
				elif Input.is_action_pressed("tecla_a"):
					
					pos_siguiente.x -= vel_desp
					
					$palo.rotation_degrees = 270
					
					vel_actual.x = -vel_desp*delta/$AnimationPlayer.get_animation("Walk_side").length
					
					$AnimationPlayer.play("Walk_side")
					
					$Sprite.flip_h = false
					
				elif Input.is_action_pressed("tecla_d"):
					
					pos_siguiente.x += vel_desp
					
					$palo.rotation_degrees = 90
					
					vel_actual.x =  vel_desp*delta/$AnimationPlayer.get_animation("Walk_side").length
					
					$AnimationPlayer.play("Walk_side")
					
					$Sprite.flip_h = true
				
				elif(Input.is_action_just_pressed("tecla_start")):
					Gamelogic.estado_actual = Gamelogic.estados.menu_juego
					get_tree().get_nodes_in_group("menu")[0].visible = true
					
				
				var n_tile = get_tree().get_nodes_in_group("tile")[0].get_cellv(get_tree().get_nodes_in_group("tile")[0].world_to_map($palo/pos.global_position))
				
				if n_tile != -1:
					n_tile = get_tree().get_nodes_in_group("tile")[0].tile_set.tile_get_name(n_tile)
					
					if(n_tile != "escalera" and n_tile != "puerta" and n_tile != "puerta2" and n_tile != "escalera2" and n_tile != "silla" and n_tile != "pasto"):
						vel_actual = Vector2(0,0)
						pos_siguiente = global_position
				
				check_raycast()
				
			else:
				var d = position.distance_to(path[0])
				if (d > 8):
					if(abs(global_position.x - path[0].x) > abs(global_position.y - path[0].y)):
						if(global_position.x > path[0].x):
							mover(2)
						else:
							mover(3)
					else:
						if(global_position.y > path[0].y):
							mover(0)
						else:
							mover(1)
				else:
					path.remove(0)
		if $AnimationPlayer.is_playing():
			
			move_and_collide(vel_actual)
	elif(main.texto_on):
		
		if Input.is_action_just_pressed("tecla_x"):
			
			Gamelogic.procesar_texto()
			
	elif(Gamelogic.mapa_Abierto):
		if Input.is_action_just_pressed("tecla_z"):
			Gamelogic.abrirMapa(false)

func _on_AnimationPlayer_animation_finished(anim_name):
	
	vel_actual = Vector2(0,0)
	
	global_position = pos_siguiente
	
	var n_tile = get_tree().get_nodes_in_group("tile")[0].get_cellv(get_tree().get_nodes_in_group("tile")[0].world_to_map(global_position))
	n_tile = get_tree().get_nodes_in_group("tile")[0].tile_set.tile_get_name(n_tile)
	if n_tile == "escalera" or n_tile == "puerta" or n_tile == "escalera2" or n_tile == "puerta2":  #Escalera
		
		main.check_door(get_tree().get_nodes_in_group("tile")[0].world_to_map(global_position))
	if(n_tile == "pasto"):
		if Gamelogic.pise_pasto == false:
			Gamelogic.pise_pasto = true
			get_tree().get_nodes_in_group("nivel")[0].procesar_instancia()
		else:
			pass #Posibilidad de encontrar PKM

func interactuar_tile():
	
	var objeto_frente = get_tree().get_nodes_in_group("tile")[0].get_cellv(get_tree().get_nodes_in_group("tile")[0].world_to_map($palo/pos.global_position))
	
	print(objeto_frente)
	
	objeto_frente = get_tree().get_nodes_in_group("tile")[0].tile_set.tile_get_name(objeto_frente)
	
	print(get_tree().get_nodes_in_group("tile")[0].world_to_map($palo/pos.global_position))
	
	match(objeto_frente):
		"pc": #pc
			Gamelogic.generar_texto(290)
		"tv": #tele
			Gamelogic.generar_texto(284)
		"consola": #consola
			Gamelogic.generar_texto(285)
		"cama": #cama
			Gamelogic.generar_texto(objeto_frente)
		"biblio": #estanteria casa ash
			Gamelogic.generar_texto(247)
		"cartel":  #Cartel Casa de ash
			Gamelogic.generar_texto(4)
		"cartel2": #Cartel Casa de Enemigo
			Gamelogic.generar_texto(318)
		"cartel3": #Cartel
			Gamelogic.generar_texto(320)
		"cartel4": #Cartel
			Gamelogic.generar_texto(319)
		"mapa":
			Gamelogic.generar_texto(5)
		"manuscrito":
			Gamelogic.generar_texto(7)
	if("pcoak" in objeto_frente):
		Gamelogic.generar_texto(6)
	

func procesar_raycast():
	var obj_col = $palo/RayCast2D.get_collider()
	if (obj_col != null):
		if(obj_col.is_in_group("npc")):
			match(int($palo.rotation_degrees)):
				0:
					obj_col.interaccion(0) #arr
				90:
					obj_col.interaccion(1) #der
				180:
					obj_col.interaccion(2) #abajo
				270:
					obj_col.interaccion(3) #izq
		elif(obj_col.is_in_group("item")):
			obj_col.interaccion()

func check_raycast():
	$palo/RayCast2D.force_raycast_update()
	var obj_col = $palo/RayCast2D.get_collider()
	if (obj_col != null and (obj_col.is_in_group("npc") or obj_col.is_in_group("player"))):
		vel_actual = Vector2(0,0)  #Anulamos movimientos
		pos_siguiente = global_position
		
func create_path():
	path = nav.get_simple_path(global_position, objetivo, false)
	
func mover(var valor):
	match(valor):
		0: #Arriba
			pos_siguiente.y -= vel_desp
			
			$palo.rotation_degrees = 0
			
			vel_actual.y = -vel_desp*get_physics_process_delta_time()/$AnimationPlayer.get_animation("walk_up").length
			
			$AnimationPlayer.play("walk_up")
		1: #Abajo
			pos_siguiente.y += vel_desp
			
			$palo.rotation_degrees = 180
			
			vel_actual.y = vel_desp*get_physics_process_delta_time()/$AnimationPlayer.get_animation("walk_up").length
			
			$AnimationPlayer.play("walk_down")
		2: #Izquierda
			
			pos_siguiente.x -= vel_desp
			
			$palo.rotation_degrees = 270
			
			vel_actual.x = -vel_desp*get_physics_process_delta_time()/$AnimationPlayer.get_animation("walk_up").length
			
			$AnimationPlayer.play("Walk_side")
			
			$Sprite.flip_h = false
			
		3: #Derecha
			pos_siguiente.x += vel_desp
			
			$palo.rotation_degrees = 90
			
			vel_actual.x = vel_desp*get_physics_process_delta_time()/$AnimationPlayer.get_animation("walk_up").length
			
			$AnimationPlayer.play("Walk_side")
			
			$Sprite.flip_h = true
