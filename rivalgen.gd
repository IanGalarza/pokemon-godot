extends Node

var rival_data = {
	numero = "",
	nombre = "",
	dinero = "",
	texto1 = "",
	texto2 = "",
	texto3 = "",
	texto4 = "",
	texto5 = "",
	texto6 = "",
	texto7 = "",
	pkm1_n = "",
	pkm1_l = "",
	pkm2_n = "",
	pkm2_l = "",
	pkm3_n = "",
	pkm3_l = "",
	pkm4_n = "",
	pkm4_l = "",
	pkm5_n = "",
	pkm5_l = "",
	pkm6_n = "",
	pkm6_l = "",
	img = ""
	}



# Called when the node enters the scene tree for the first time.
func cargar_rival(numero):
	var file = File.new()
	if(!file.file_exists("res://Data/Rivales/" + String(numero) + ".dat")):
		return
		
	file.open("res://Data/Rivales/" + String(numero) + ".dat", File.READ)
	
	var rival = rival_data
	
	rival.numero = numero
	
	var data = rival_data
	
	if(!file.eof_reached()):
		data = parse_json(file.get_line())
		
	
	rival.nombre = data.nombre
	rival.dinero = data.dinero
	rival.texto1 = data.texto1
	rival.texto2 = data.texto2
	rival.texto3 = data.texto3
	rival.texto4 = data.texto4
	rival.texto5 = data.texto5
	rival.texto6 = data.texto6
	rival.texto7 = data.texto7
	rival.pkm1_n = data.pkm1_n
	rival.pkm1_l = data.pkm1_l
	rival.pkm2_n = data.pkm2_n
	rival.pkm2_l = data.pkm2_l
	rival.pkm3_n = data.pkm3_n
	rival.pkm3_l = data.pkm3_l
	rival.pkm4_n = data.pkm4_n
	rival.pkm4_l = data.pkm4_l
	rival.pkm5_n = data.pkm5_n
	rival.pkm5_l = data.pkm5_l
	rival.pkm6_n = data.pkm6_n
	rival.pkm6_l = data.pkm6_l
	rival.img = data.img
	
	return rival
	

func guardar_rival(rival):
	var path = Directory.new()
	if(!path.dir_exists("res://Data/Rivales/" + String(rival.numero) + ".dat")):
		path.make_dir("res://Data/Rivales/" + String(rival.numero) + ".dat")
		
	var file = File.new()
	file.open("res://Data/Rivales/" + String(rival.numero) + ".dat", File.WRITE)
	
	var data = rival
	
	file.store_line(to_json(data))
	
	file.close()
