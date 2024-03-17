extends KinematicBody2D

export (Array) var dialogo_1
export (bool) var movil #Se mueve o no el NPC
export (float) var t_mov #tiempo de movimiento
export (bool) var en_lugar #Se mueve en el lugar, mira para todos lados


var main
var vel_actual = Vector2()
var vel_desp = 16
var pos_siguiente = Vector2()


func _ready():
	if(dialogo_1.size() > 0):
		for i in dialogo_1.size():
			if("player_name" in dialogo_1[i]):
				dialogo_1[i] = dialogo_1[i].replace("player_name", Gamelogic.player_name)
			if("rival_name" in dialogo_1[i]):
				dialogo_1[i]= dialogo_1[i].replace("rival_name", Gamelogic.rival_name)
	main = get_tree().get_nodes_in_group("main")[0]
	if (movil or en_lugar):
		yield(get_tree().create_timer(t_mov),"timeout")
		try_move()

func _physics_process(delta):
	if (!main.cargando_escena):
		
		if $AnimationPlayer.is_playing():
			
			pos_siguiente = global_position
			
			move_and_collide(vel_actual)
	
	
func check_mov():
	
	var n_tile = get_tree().get_nodes_in_group("tile")[0].get_cellv(get_tree().get_nodes_in_group("tile")[0].world_to_map($Palo/pos.global_position))
	
	if n_tile != -1:
		vel_actual = Vector2(0,0)
		pos_siguiente = global_position
	
	

func interaccion(direccion):
	
	Gamelogic.generar_texto_char(dialogo_1.duplicate())
	
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

func try_move():   #Intentar mover
	if(rand_range(0,1.1) < 0.5 and !main.texto_on):
		if(movil):
			mover()
		elif(en_lugar):
			mover_cara()
			
	yield(get_tree().create_timer(t_mov),"timeout")
	try_move()
	

func mover():
	match(randi()%4):
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
	
	check_limites()
	
	check_mov()
	
	check_raycast()
	

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
	
	

