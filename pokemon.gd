extends Node

enum estados_pokemon {ok, faint, poison, freeze, burn, sleep, confuse}

var pokemon = {
	nombre = "",
	tipo = "",
	hp = "",
	hp_max = "",
	nivel = "",
	experiencia = "",
	atk = "",
	def = "",
	spd = "",
	spc = "",
	atk1 = "",
	atk1_pp = 0,
	atk1_ppmax = 0,
	atk2 = "",
	atk2_pp = 0,
	atk2_ppmax = 0,
	atk3 = "",
	atk3_pp = 0,
	atk3_ppmax = 0,
	atk4 = "",
	atk4_pp = 0,
	atk4_ppmax = 0,
	estado = estados_pokemon.ok,
	ott = "" #Nombre del entrenador original
	}



func _ready():
	pass # Replace with function body.


func crear_pokemon(numero, nombre, ott, nivel):
	
	var pkmn = pokemon
	
	#Datos a modificar siempre
	if(nombre != ""):
		pkmn.nombre = nombre
	if(ott != ""):
		pkmn.ott = ott
	
	pkmn.nivel = nivel
	
	
	pkmn.numero = numero
	
	#Datos enciclopedicos
	var file = File.new()
	if(file.file_exists("res://Data/Pkmn_S/" + String(numero) + ".dat")):
		file.open("res://Data/Pkmn_S/" + String(numero) + ".dat", File.READ)
		
		var data = card_data
		
		if(!file.eof_reached()):
			data = parse_json(file.get_line())
		
		pkmn.nombre = data.nombre
		pkmn.tipo = data.tipo
		pkmn.hp_max = data.hp
		pkmn.hp = data.hp
		pkmn.experiencia = data.experiencia
		pkmn.atk = data.atk
		pkmn.def = data.def
		pkmn.spd = data.spd
		pkmn.spc = data.spc
		pkmn.atk1 = data.atk1
		pkmn.atk2 = data.atk2
		pkmn.atk3 = data.atk3
		pkmn.atk4 = data.atk4
		
		var atk_actual = 1
		
		var i = 1
		for j in 15:
			if (int(pkmn.nivel) > int(data.get("atkl" + String(i) + "_lvl"))):
				match(atk_actual):
					1:
						pkmn.atk1 = data.get("atkl" + String(i))
					2:
						pkmn.atk2 = data.get("atkl" + String(i))
					3:
						pkmn.atk3 = data.get("atkl" + String(i))
					4:
						pkmn.atk4 = data.get("atkl" + String(i))
				atk_actual += 1
				if (atk_actual > 4):
					atk_actual = 1
			i += 1
		
		file.close()
		
	else:
		print("no se cargo la data")
		return
	
	return pkmn
	
	












var card_data = {
	nombre = "",
	tipo = "",
	hp = "",
	nivel = "",
	experiencia = "",
	atk = "",
	def = "",
	spd = "",
	spc = "",
	atk1 = "",
	atk2 = "",
	atk3 = "",
	atk4 = "",
	evol = "",
	atkl1 = "",
	atkl1_lvl = "",
	atkl2 = "",
	atkl2_lvl = "",
	atkl3 = "",
	atkl3_lvl = "",
	atkl4 = "",
	atkl4_lvl = "",
	atkl5 = "",
	atkl5_lvl = "",
	atkl6 = "",
	atkl6_lvl = "",
	atkl7 = "",
	atkl7_lvl = "",
	atkl8 = "",
	atkl8_lvl = "",
	atkl9 = "",
	atkl9_lvl = "",
	atkl10 = "",
	atkl10_lvl = "",
	atkl11 = "",
	atkl11_lvl = "",
	atkl12 = "",
	atkl12_lvl = "",
	atkl13 = "",
	atkl13_lvl = "",
	atkl14 = "",
	atkl14_lvl = "",
	atkl15 = "",
	atkl15_lvl = "",
	}
	
	
	
	
	
	
	
