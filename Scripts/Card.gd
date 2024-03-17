extends Node2D

var card_data = {
	nombre = "",
	tipo = "",
	altura = "",
	peso = "",
	descripcion = ""
}

var nodo_ref

func _ready():
	Gamelogic.estado_actual = Gamelogic.estados.card
	

func load_pkmn(num):
	var file = File.new()
	if(file.file_exists("res://Data/Pkmn/" + String(num) + ".dat")):
		file.open("res://Data/Pkmn/" + String(num) + ".dat", File.READ)
		
		var data = card_data
		
		if(!file.eof_reached()):
			data = parse_json(file.get_line())
		print("se cargo la data")
		$txtnum2.text = String(num)
		$txtname.text = data.nombre
		$txttipo.text = data.tipo
		$txtht2.text = data.altura
		$txtwt2.text = data.peso
		$txtdesc.text = data.descripcion
		
		$spr_pkmn.frame = num-1
		
		file.close()
		
	else:
		print("no se cargo la data")
		return
	
func _physics_process(delta):
	if Input.is_action_just_pressed("tecla_x"):
		nodo_ref.card_cancel()
		queue_free()
		
		
