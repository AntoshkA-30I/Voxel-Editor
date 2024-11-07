extends GridMap


func place_single_voxel(world_coordinate, voxel_index):
	var map_coordinate = local_to_map(world_coordinate)
	if map_coordinate.y >= 0:
		set_cell_item(map_coordinate, voxel_index)


func place_multiple_voxel(world_coordinate, voxel_index, voxel_height):
	var map_coordinate = local_to_map(world_coordinate)
	if map_coordinate.y >= 0:
		map_coordinate.y = voxel_height
		set_cell_item(map_coordinate, voxel_index)
		

func delete_voxel(world_coordinate):
	var map_coordinate = local_to_map(world_coordinate)
	set_cell_item(map_coordinate, -1)
	
