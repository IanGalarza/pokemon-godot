extends TileMap

export (float) var tiempo

func _ready():
	yield(get_tree().create_timer(tiempo), 'timeout')
	animar()
	
	

func animar():
	var tiles = get_used_cells()
	for tile in tiles:
		var id = get_cell(tile.x, tile.y)
		tile_set.tile_get_name(id)
		if tile_set.tile_get_name(id).substr(0, tile_set.tile_get_name(id).length()-1) in tile_set.tile_get_name(id+1):
			set_cell(tile.x,tile.y, id+1)
		else:
			set_cell(tile.x, tile.y, tile_set.find_tile_by_name(tile_set.tile_get_name(id).substr(0, tile_set.tile_get_name(id).length()-1)))
	yield(get_tree().create_timer(tiempo), 'timeout')
	animar()


