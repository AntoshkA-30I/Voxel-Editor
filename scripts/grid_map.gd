extends GridMap


# Функция для вставки одного вокселя
func place_single_voxel(world_coordinate, voxel_index):
	var map_coordinate = local_to_map(world_coordinate)
	print(map_coordinate)
	if map_coordinate.y >= 0:
		set_cell_item(map_coordinate, voxel_index)


# Функция для рисования вокселей
func place_multiple_voxel(world_coordinate, voxel_index, voxel_height):
	var map_coordinate = local_to_map(world_coordinate)
	if map_coordinate.y >= 0 and map_coordinate.y - voxel_height == 0:
		map_coordinate.y = voxel_height
		set_cell_item(map_coordinate, voxel_index)
		
		
# Функция для удаления одного вокселя
func delete_single_voxel(world_coordinate):
	var map_coordinate = local_to_map(world_coordinate)
	set_cell_item(map_coordinate, -1)
	
	
# Функция для стирания вокселей
func delete_multiple_voxel(world_coordinate, voxel_height):
	var map_coordinate = local_to_map(world_coordinate)
	if map_coordinate.y >= 0: #and map_coordinate.y - voxel_height == 0:
		map_coordinate.y = voxel_height
		set_cell_item(map_coordinate, -1)
