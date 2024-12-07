extends Node

@onready var grid_map = $"../GridMap"

# Функция для сохранения GridMap
func save_gridmap(path: String):
	var data = {}
	for x in range(-100, 101, 1):
		for y in range(0, 101, 1):
			for z in range(-100, 101, 1):
				var cell_item = grid_map.get_cell_item(Vector3i(x, y, z))
				if cell_item != -1: # Сохранем воксель из ячейки, если она не пустая
					data["%d_%d_%d" % [x, y, z]] = cell_item 

	var json_data = JSON.stringify(data)
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(json_data)
		file.close()
		
		
# Функция для загрузки GridMap
func load_gridmap(path: String):
	# Очищаем текущий GridMap
	for x in range(-65, 66, 1):
		for y in range(0, 66, 1):
			for z in range(-65, 66, 1):
				grid_map.set_cell_item(Vector3i(x, y, z,), -1)
				
	var file = FileAccess.open(path, FileAccess.READ) 
	if file:
		var json_data = file.get_as_text()
		file.close()
		var result = JSON.parse_string(json_data)
		if result:
			# Загружаем сохраненый GridMap
			for key in result.keys():
				var coords = key.split("_")
				var x = int(coords[0])
				var y = int(coords[1])
				var z = int(coords[2])
				var item = result[key]
				grid_map.set_cell_item(Vector3i(x, y, z), item)  # Устанавливаем воксель в ячейку
