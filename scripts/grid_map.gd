extends GridMap


func place_voxel(world_coordinate, block_index):
	var map_coordinate = local_to_map(world_coordinate)
	print(map_coordinate)
	if map_coordinate.y >= 0:
		set_cell_item(map_coordinate, block_index)


func delete_voxel(world_coordinate):
	var map_coordinate = local_to_map(world_coordinate)
	set_cell_item(map_coordinate, -1)
	
	
func preview_voxel(world_coordinate):
	pass
