extends CharacterBody3D


var move_sensitivity = 5.0
var sensitivity = 0.005
var current_zoom = Vector3(1, 1, 1)

var voxel_collider
var voxel_color
var voxel_height
var current_tool

@onready var grid_map = $"../GridMap"
@onready var camera = $Camera3D
@onready var ray_cast = $Camera3D/RayCast3D
@onready var menu_file = $PanelContainer3/VBoxContainer/MarginContainer/HBoxContainer/MenuButton_File
@onready var menu_edit = $PanelContainer3/VBoxContainer/MarginContainer/HBoxContainer/MenuButton_Edit
@onready var menu_help = $PanelContainer3/VBoxContainer/MarginContainer/HBoxContainer/MenuButton_Help
@onready var color_list_ui = $PanelContainer3/VBoxContainer/HBoxContainer2/MarginContainer2/color_list
@onready var tool_list_ui = $PanelContainer3/VBoxContainer/HBoxContainer2/MarginContainer/tool_list
var mouse_position : Vector2

var undo_redo: UndoRedo = UndoRedo.new()


func _ready() -> void:
	menu_file.get_popup().add_item("Open file")
	menu_file.get_popup().add_item("Save as")
	menu_file.get_popup().add_item("Quit")
	menu_file.get_popup().id_pressed.connect(_on_item_menu_file_pressed)
	
	menu_edit.get_popup().add_item("Undo")
	menu_edit.get_popup().add_item("Redo")
	menu_edit.get_popup().id_pressed.connect(_on_item_menu_edit_pressed)
	
	menu_help.get_popup().add_item("Manual")
	menu_help.get_popup().id_pressed.connect(_on_item_menu_help_pressed)
	
	color_list_ui.select(0)
	tool_list_ui.select(0)


func _on_item_menu_file_pressed(id):
	var item_name = menu_file.get_popup().get_item_text(id)
	if item_name == "Open file":
		pass
	elif item_name == "Save as":
		pass
	elif item_name == "Quit":
		get_tree().quit()

func _on_item_menu_edit_pressed(id):
	var item_name = menu_edit.get_popup().get_item_text(id)
	if item_name == "Undo":
		_on_undo_button_down()
	elif item_name == "Redo":
		_on_redo_button_down()

func _on_item_menu_help_pressed(id):
	var item_name = menu_help.get_popup().get_item_text(id)
	if item_name == "Manual":
		var url = "https://github.com/AntoshkA-30I/Voxel-Editor/blob/main/README.md"
		OS.shell_open(url)


func _mouse_ray_cast() -> GridMap:
	mouse_position = get_viewport().get_mouse_position()
	ray_cast.target_position = camera.project_local_ray_normal(mouse_position) * 100.0
	ray_cast.force_raycast_update()
		
	if ray_cast.is_colliding():
		return ray_cast.get_collider()
	return null


func _on_undo_button_down() -> void:
	undo_redo.undo()

func _on_redo_button_down() -> void:
	undo_redo.redo()


#------------------------------------------------------------------------------------------------------#	
func _process(delta: float) -> void:
	#---move
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * move_sensitivity * current_zoom.x 
		velocity.z = direction.z * move_sensitivity * current_zoom.x 
	else:
		velocity.x = move_toward(velocity.x, 0, move_sensitivity)
		velocity.z = move_toward(velocity.z, 0, move_sensitivity)
	move_and_slide()
	
	
func _unhandled_input(event: InputEvent) -> void:
	voxel_color = color_list_ui.get_selected_items()[0]
	current_tool = tool_list_ui.get_selected_items()[0]
	
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
	
#---paste single voxel 
	if Input.is_action_just_pressed("mouse_left") and current_tool == 0:
		voxel_collider = _mouse_ray_cast()
		if voxel_collider != null:
			undo_redo.create_action("paste single voxel")
			undo_redo.add_do_method(voxel_collider.place_single_voxel.bind(ray_cast.get_collision_point() + ray_cast.get_collision_normal()/2, voxel_color))
			undo_redo.add_undo_method(voxel_collider.delete_voxel.bind(ray_cast.get_collision_point()))
			undo_redo.commit_action()
			
			#voxel_collider.place_single_voxel(ray_cast.get_collision_point() + ray_cast.get_collision_normal()/2, voxel_color)

#---paste multiple voxel
	if Input.is_action_just_pressed("mouse_left") and current_tool == 1:
		mouse_position = get_viewport().get_mouse_position()
		ray_cast.target_position = camera.project_local_ray_normal(mouse_position) * 100.0
		ray_cast.force_raycast_update()
		voxel_height = (grid_map.local_to_map(ray_cast.get_collision_point() + ray_cast.get_collision_normal()/2)).y
	if Input.is_action_pressed("mouse_left") and current_tool == 1:
		voxel_collider = _mouse_ray_cast()
		if voxel_collider != null:
			undo_redo.create_action("paste multiple voxel")
			undo_redo.add_do_method(voxel_collider.place_multiple_voxel.bind(ray_cast.get_collision_point() + ray_cast.get_collision_normal()/2, voxel_color, voxel_height))
			undo_redo.add_undo_method(voxel_collider.delete_voxel.bind(ray_cast.get_collision_point()))
			undo_redo.commit_action()
			
			
#---delete voxel
	if Input.is_action_just_pressed("mouse_right"):
		voxel_collider = _mouse_ray_cast()
		var map_coordinate = grid_map.local_to_map(ray_cast.get_collision_point() - ray_cast.get_collision_normal())
		if voxel_collider != null and grid_map.get_cell_item(map_coordinate) != 4:
			undo_redo.create_action("delete multiple voxel")
			undo_redo.add_do_method(voxel_collider.delete_voxel.bind(ray_cast.get_collision_point() - ray_cast.get_collision_normal()))
			undo_redo.add_undo_method(voxel_collider.place_single_voxel.bind(ray_cast.get_collision_point() - ray_cast.get_collision_normal()/2, voxel_color))
			undo_redo.commit_action()
			#voxel_collider.delete_voxel(ray_cast.get_collision_point() - ray_cast.get_collision_normal())
		
