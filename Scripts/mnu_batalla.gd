extends Node2D

var opc_act = 1
var enemigo

func _ready():
	pass # Replace with function body.
	

func _physics_process(delta):
	if(Input.is_action_just_pressed("tecla_a")):
		if(opc_act - 2 >= 1):
			opc_act -= 2
	elif(Input.is_action_just_pressed("tecla_d")):
		if(opc_act + 2 <= 4):
			opc_act += 2

	elif(Input.is_action_just_pressed("tecla_s")):
		opc_act += 1
		if(opc_act > 4):
			opc_act = 1
		
	elif(Input.is_action_just_pressed("tecla_w")):
		opc_act -= 1
		if(opc_act < 1):
			opc_act = 4
			
	update_cursor()
			
func update_cursor():
	$bkg_op1/c1.global_position = get_node("bkg_op1").get_node(String(opc_act)).get_node("p").global_position


func cargar_datos(rival):
	enemigo = rival
	
	enemigo = Rivalgen.cargar_rival(enemigo.rival_n)
	
