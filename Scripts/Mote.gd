extends CanvasLayer

var pos_act = 1
var c_act = 1 #Casillero actual
var estado = 0 #0 Menu principal, 1 juego


func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("tecla_x"):
		
		if (pos_act < 27):  #escribimos
			
			if (c_act < 7):
				var letra = get_node(String(pos_act)).get_child(0).text #Obtengo el hijo (unico elemento)
				get_node("cas" + String(c_act)).text = letra
			
			if(c_act < 7):
			
				c_act += 1
			
		elif(pos_act == 27):    #Borramos
			if (c_act > 1): #borramos
				c_act -= 1
				get_node("cas" + String(c_act)).text = "_"
		
		
		elif(pos_act == 28): #Fin
			if(estado == 0): #Menu Principal
				var nombre_final = ""
				for i in c_act-1:  #Agrega todos los nodos hasta el actual ubicado (Solamente si tienen letra)
					nombre_final += get_node("cas"+String(i+1)).text
				get_tree().get_nodes_in_group("main")[0].nombre_mote = nombre_final
				Gamelogic.estado_actual = Gamelogic.estados.menu_ppal
				get_tree().get_nodes_in_group("main")[0].procesar_name()
				queue_free()
			
	if (Input.is_action_just_pressed('tecla_z')): 
		if (c_act > 1): #borramos
			c_act -= 1
			get_node("cas" + String(c_act)).text = "_"
			
			
	if Input.is_action_just_pressed("tecla_w"):
		if(pos_act > 9):
			pos_act -= 9
			update_select()
	if Input.is_action_just_pressed("tecla_a"):
		if(pos_act != 1):
			pos_act -= 1
			update_select()
	if Input.is_action_just_pressed("tecla_s"):
		if(pos_act <= 18 or pos_act == 27):
			if (pos_act == 27):
				pos_act = 28
			else:
				pos_act += 9
			update_select()
	if Input.is_action_just_pressed("tecla_d"):
		if(pos_act != 28):
			pos_act += 1
			update_select()

func update_select():
	$cursor.global_position = get_node(String(pos_act)).global_position

