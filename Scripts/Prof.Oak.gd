extends KinematicBody2D

export (Array) var dialogo_1
export (Array) var dialogo_2
export (Array) var dialogo_3
export (Array) var dialogo_4
export (Array) var dialogo_5
export (Array) var dialogo_6

export (float) var t_mov #tiempo de movimiento
export (bool) var en_lugar #Se mueve en el lugar, mira para todos lados


var main
var vel_actual = Vector2()
var vel_desp = 16
var pos_siguiente = Vector2()

var path = []
var objetivo = Vector2()
var nav = Navigation2D



func _ready():
	pos_siguiente = global_position
	nav = get_tree().get_nodes_in_group("nav")[0]
	if(get_parent().name == "Nivel3"):
		Gamelogic.reemplazar_nombre(dialogo_1)
		Gamelogic.reemplazar_nombre(dialogo_2)
	elif(get_parent().name == "Nivel4"):
		Gamelogic.reemplazar_nombre(dialogo_3)
	main = get_tree().get_nodes_in_group("main")[0]
	if(get_parent().name == "Nivel3"):
		if (en_lugar):
			yield(get_tree().create_timer(t_mov),"timeout")
		_interaccion(2, dialogo_1)
		objetivo = get_tree().get_nodes_in_group("player")[0].global_position + Vector2(0,16)
		create_path()

func _physics_process(delta):
	if (!main.cargando_escena):
		if (!$AnimationPlayer.is_playing()):
			pos_siguiente = global_position
		if(!$AnimationPlayer.is_playing() and !path.size() == 0):
			var d = position.distance_to(path[0])
			if (d > 8):
				if abs(global_position.x - path[0].x) > abs(global_position.y - path[0].y):
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
		elif(path.size() == 0):
			
			if(get_parent().name == "Nivel3"):
				var nivel3 = get_tree().get_nodes_in_group("nivel")[0]
				if (nivel3.instancia == 1 and get_tree().get_nodes_in_group("main")[0].texto_on == false):
					nivel3.instancia += 1
					_interaccion(2, dialogo_2)
				elif(nivel3.instancia == 2 and get_tree().get_nodes_in_group("main")[0].texto_on == false):
					nivel3.instancia += 1
					nivel3.procesar_instancia()
				elif(nivel3.instancia == 3):
					nivel3.instancia += 1
					nivel3.procesar_instancia()
			if(get_parent().name == "Nivel4"):
				var nivel4 = get_tree().get_nodes_in_group("nivel")[0]
				if(nivel4.instancia == 3):
					yield(get_tree().create_timer(0.5),"timeout")
					nivel4.instancia = 4
					_interaccion(0,dialogo_3)
					main.save_data(4, nivel4)
					
				
		if $AnimationPlayer.is_playing():
			
			pos_siguiente = global_position
			
			move_and_collide(vel_actual)
	
	
func check_mov():
	
	var n_tile = get_tree().get_nodes_in_group("tile")[0].get_cellv(get_tree().get_nodes_in_group("tile")[0].world_to_map($Palo/pos.global_position))
	
	if n_tile != -1:
		vel_actual = Vector2(0,0)
		pos_siguiente = global_position
	
	

func _interaccion(direccion, dial):
	
	Gamelogic.generar_texto_char(dial.duplicate())
	
	match(direccion):
		
		0: #abajo
			$AnimationPlayer.play("abajo")
			
		1: #izq
			$AnimationPlayer.play("izq")
			$Sprite.flip_h = false
		2: #arriba
			$AnimationPlayer.play("arr")
			
		3: #der
			$AnimationPlayer.play("izq")
			$Sprite.flip_h = true

func interaccion(direccion):
	var nivel = get_tree().get_nodes_in_group("nivel")[0]
	match(nivel.instancia):
		4: #Tiene que elegir el pokemon
			Gamelogic.generar_texto_char(dialogo_5.duplicate())
		8:
			Gamelogic.generar_texto_char(dialogo_6.duplicate())
			
	match(direccion):
		
		0: #abajo
			$AnimationPlayer.play("abajo")
			
		1: #izq
			$AnimationPlayer.play("izq")
			$Sprite.flip_h = false
		2: #arriba
			$AnimationPlayer.play("arr")
			
		3: #der
			$AnimationPlayer.play("izq")
			$Sprite.flip_h = true

func mover(var valor):
	match(valor):
		0: #Arriba
			pos_siguiente.y -= vel_desp
			
			$Palo.rotation_degrees = 0
			
			vel_actual.y = -vel_desp*get_physics_process_delta_time()/$AnimationPlayer.get_animation("mov_arr").length
			
			$AnimationPlayer.play("mov_arr")
		1: #Abajo
			pos_siguiente.y += vel_desp
			
			$Palo.rotation_degrees = 180
			
			vel_actual.y = vel_desp*get_physics_process_delta_time()/$AnimationPlayer.get_animation("mov_arr").length
			
			$AnimationPlayer.play("mov_abj")
		2: #Izquierda
			
			pos_siguiente.x -= vel_desp
			
			$Palo.rotation_degrees = 270
			
			vel_actual.x = -vel_desp*get_physics_process_delta_time()/$AnimationPlayer.get_animation("mov_arr").length
			
			$AnimationPlayer.play("mov_izq")
			
			$Sprite.flip_h = false
			
		3: #Derecha
			pos_siguiente.x += vel_desp
			
			$Palo.rotation_degrees = 90
			
			vel_actual.x = vel_desp*get_physics_process_delta_time()/$AnimationPlayer.get_animation("mov_arr").length
			
			$AnimationPlayer.play("mov_izq")
			
			$Sprite.flip_h = true
	
	#check_limites()
	
	#check_mov()
	
	#check_raycast()
	

func mover_cara():
	match(randi()%4):
		0: #Arriba
			$Palo.rotation_degrees = 0
			$AnimationPlayer.play("arr")
		1: #Abajo
			$Palo.rotation_degrees = 180
			$AnimationPlayer.play("abajo")
		2: #Izquierda
			$Palo.rotation_degrees = 270
			$AnimationPlayer.play("izq")
			$Sprite.flip_h = false
		3: #Derecha
			$Palo.rotation_degrees = 90
			$AnimationPlayer.play("izq")
			$Sprite.flip_h = true

	
	
func _on_AnimationPlayer_animation_finished(anim_name):
	vel_actual = Vector2(0,0)
	
	global_position = pos_siguiente
	

func check_raycast():
	
	$Palo/RayCast2D.force_raycast_update()
	
	var obj_col = $Palo/RayCast2D.get_collider()
	
	if (obj_col != null and (obj_col.is_in_group("npc") or obj_col.is_in_group("player"))):
		vel_actual = Vector2(0,0)  #Anulamos movimientos
		pos_siguiente = global_position
	
func check_limites():
	if(pos_siguiente.x > $limites/max.global_position.x or pos_siguiente.x < $limites/min.global_position.x or pos_siguiente.y > $limites/max.global_position.y or pos_siguiente.y < $limites/min.global_position.y):
		vel_actual = Vector2(0,0)  #Anulamos movimientos
		pos_siguiente = global_position
	
func create_path():
	path = nav.get_simple_path(global_position, objetivo, false)
	

func add_path(num):
	
	var vel_act = Vector2()
	match(num):
		0: #Arriba
			vel_act += Vector2(0,-16)
			
		1: #Abajo
			vel_act += Vector2(0,16)
		2: #Izquierda
			vel_act += Vector2(-16,0)
		3: #Derecha
			vel_act += Vector2(16,0)
	
	if(path.size() > 0):
		path.append(path[path.size()-1] + vel_act)
	else:
		path.append(global_position+vel_act)
