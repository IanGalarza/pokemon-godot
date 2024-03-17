extends Node2D

export (PackedScene) var profOAK

var instancia = 1
var main


var datos = {
	instancia = ""
}

func _ready():
	main = get_tree().get_nodes_in_group("main")[0]
	main.try_load_lvl_instance(3, self)

func procesar_instancia():
	match(instancia):
		1:
			var newProf = profOAK.instance()
			newProf.global_position = get_node("spawn_OAK").global_position
			add_child(newProf)
		3:
			var oak = get_tree().get_nodes_in_group("oak")[0]
			oak.objetivo = $spawn_j3.global_position
			oak.objetivo += Vector2(16,0)
			oak.create_path()
			oak.path.remove(0)
			
			var jugador = get_tree().get_nodes_in_group("player")[0]
			jugador.objetivo = $spawn_j3.global_position
			jugador.create_path()
			jugador.path.remove(0)
		4:
			var jugador = get_tree().get_nodes_in_group("player")[0]
			var main = get_tree().get_nodes_in_group("main")[0]
			var lab_oak = jugador.objetivo + Vector2(0,-16)
			main.check_door(get_tree().get_nodes_in_group("tile")[0].world_to_map(lab_oak))
			instancia += 1
			save_data_special()
		5:
			pass
	

func save_data_special():
	
	var data = datos
	data.instancia = instancia
	
	var path = Directory.new()
	
	if(!path.dir_exists("res://Data/Maps/provis")):
		path.make_dir("res://Data/Maps/provis")
	
	var file = File.new()
	file.open("res://Data/Maps/provis/3.dat", File.WRITE)
	
	file.store_line(to_json(data))
	
	file.close()
	
	#LAB OAK
	file = File.new()
	file.open("res://Data/Maps/provis/4.dat", File.WRITE)
	
	file.store_line(to_json(2))
	
	file.close()
	
