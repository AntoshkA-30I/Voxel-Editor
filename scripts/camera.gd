extends CharacterBody3D


var move_sensitivity = 9.0
var sensitivity = 0.005
var current_zoom = Vector3(1, 1, 1)

@onready var grid_map = $"../GridMap"
@onready var camera = $Camera3D
@onready var ray_cast = $Camera3D/RayCast3D
var mouse_position : Vector2

var current_voxel


func _ready() -> void:
	pass


func _process(delta: float) -> void:
#---move
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * move_sensitivity
		velocity.z = direction.z * move_sensitivity
	else:
		velocity.x = move_toward(velocity.x, 0, move_sensitivity)
		velocity.z = move_toward(velocity.z, 0, move_sensitivity)
	move_and_slide()
	
#---paste voxel
	if Input.is_action_just_pressed("mouse_left"):
		mouse_position = get_viewport().get_mouse_position()
		ray_cast.target_position = camera.project_local_ray_normal(mouse_position) * 100.0
		ray_cast.force_raycast_update()
		
		if ray_cast.is_colliding():
			if ray_cast.get_collider().has_method("place_voxel"):
				ray_cast.get_collider().place_voxel(ray_cast.get_collision_point() + ray_cast.get_collision_normal()/2, 1)

#---delete voxel
	if Input.is_action_just_pressed("mouse_right"):
		mouse_position = get_viewport().get_mouse_position()
		ray_cast.target_position = camera.project_local_ray_normal(mouse_position) * 100.0
		ray_cast.force_raycast_update()
		
		var map_coordinate = grid_map.local_to_map(ray_cast.get_collision_point() - ray_cast.get_collision_normal())
	
		if ray_cast.is_colliding():
			if ray_cast.get_collider().has_method("delete_voxel") and grid_map.get_cell_item(map_coordinate) != 4:
				ray_cast.get_collider().delete_voxel(ray_cast.get_collision_point() - ray_cast.get_collision_normal())


func _unhandled_input(event: InputEvent) -> void:
#---camera rotation
	if Input.is_action_pressed('mouse_middle') and not Input.is_action_pressed('shift') and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		rotate_object_local(Vector3.LEFT, event.relative.y * sensitivity)
		
#---camera zoom
	if Input.is_action_just_released('wheel_down') and current_zoom < Vector3(50, 50, 50):
		current_zoom = get_scale() + Vector3(1, 1, 1) * sensitivity * 50
		scale = current_zoom
		
	if Input.is_action_just_released('wheel_up') and current_zoom > Vector3(1, 1, 1):
		current_zoom = get_scale() - Vector3(1, 1, 1) * sensitivity * 50
		scale = current_zoom
		
