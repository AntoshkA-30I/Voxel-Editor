extends CharacterBody3D


var move_sensitivity = 5.0
var sensitivity = 0.005
var current_zoom = Vector3(1, 1, 1)
var mouse_position : Vector2
var undo_redo: UndoRedo = UndoRedo.new()

var voxel_collider
var voxel_color
var voxel_height
var current_tool

@onready var fd_save = $fd_save
@onready var fd_load = $fd_load
@onready var save_load_node = $"../save_load_node"
@onready var grid_map = $"../GridMap"
@onready var camera = $Camera3D
@onready var camera_center = $"."
@onready var ray_cast = $Camera3D/RayCast3D
@onready var menu_file = $PanelContainer3/VBoxContainer/MarginContainer/HBoxContainer/MenuButton_File
@onready var menu_edit = $PanelContainer3/VBoxContainer/MarginContainer/HBoxContainer/MenuButton_Edit
@onready var menu_help = $PanelContainer3/VBoxContainer/MarginContainer/HBoxContainer/MenuButton_Help
@onready var color_list_ui = $PanelContainer3/VBoxContainer/HBoxContainer2/MarginContainer2/color_list
@onready var tool_list_ui = $PanelContainer3/VBoxContainer/HBoxContainer2/MarginContainer/tool_list
@onready var center_camera_button = $PanelContainer3/VBoxContainer/HBoxContainer2/MarginContainer3/Button
@onready var sun_rotation_slider = $PanelContainer3/VBoxContainer/HBoxContainer2/sun_rotation/VBoxContainer/HScrollBar
@onready var sun_rotation_slider_label = $PanelContainer3/VBoxContainer/HBoxContainer2/sun_rotation/VBoxContainer/Label
@onready var sun = $"../DirectionalLight3D"


func _ready() -> void:
	menu_file.get_popup().add_item("Открыть")
	menu_file.get_popup().add_item("Сохранить")
	menu_file.get_popup().add_item("Выйти")
	menu_file.get_popup().id_pressed.connect(_on_item_menu_file_pressed)
	
	menu_edit.get_popup().add_item("Отменить")
	menu_edit.get_popup().add_item("Повторить")
	menu_edit.get_popup().id_pressed.connect(_on_item_menu_edit_pressed)
	
	menu_help.get_popup().add_item("Руководство")
	menu_help.get_popup().id_pressed.connect(_on_item_menu_help_pressed)
	
	color_list_ui.select(0)
	tool_list_ui.select(0)
	
	fd_load.filters = [
		"*.txt",  # Файлы с расширением .txt
	]
	fd_save.current_dir = '/'
	fd_load.current_dir = '/'
	
#---------------------------------------------------------------------------------------------------#
# Вкладка Filе
func _on_item_menu_file_pressed(id):
	var item_name = menu_file.get_popup().get_item_text(id)
	if item_name == "Открыть":
		fd_load.visible = true
	elif item_name == "Сохранить":
		fd_save.visible = true
	elif item_name == "Выйти":
		get_tree().quit()

# Вкладка Edit
func _on_item_menu_edit_pressed(id):
	var item_name = menu_edit.get_popup().get_item_text(id)
	if item_name == "Отменить":
		_on_undo_button_down()
	elif item_name == "Повторить":
		_on_redo_button_down()

# Вкладка Help
func _on_item_menu_help_pressed(id):
	var item_name = menu_help.get_popup().get_item_text(id)
	if item_name == "Руководство":
		var url = "https://github.com/AntoshkA-30I/Voxel-Editor/blob/main/README.md"
		OS.shell_open(url)


func _on_file_dialog_dir_selected(dir: String) -> void:
	var save_file_name = Time.get_time_string_from_system().replace(':', '_')
	save_load_node.save_gridmap(dir + '/' + save_file_name + '.txt')

func _on_fd_load_file_selected(path: String) -> void:
	save_load_node.load_gridmap(path)


# Центрирование камеры
func	 _camera_to_center() -> void:
	camera_center.set_global_position(Vector3(0, 0, 0))
	current_zoom = Vector3(1, 1, 1)
	scale = current_zoom
	
func _on_button_pressed() -> void:
	_camera_to_center()
	
	
# Вращение освещения
func _on_h_scroll_bar_scrolling() -> void:
	var value = sun_rotation_slider.value * 3.6
	sun.set_global_rotation_degrees(Vector3(-45, value, 0))
	sun_rotation_slider_label.text = str(int(value)) + '°'

func update_sun_rotation(mouse_motion: float):
	sun_rotation_slider.value += mouse_motion * 0.001 
	var value = sun_rotation_slider.value * 3.6
	sun.set_global_rotation_degrees(Vector3(-45, value, 0))
	sun_rotation_slider_label.text = str(int(value)) + '°'
	
	
# отмена и возврат
func _on_undo_button_down() -> void:
	undo_redo.undo()

func _on_redo_button_down() -> void:
	undo_redo.redo()


# Рейкастинг мыши
func _mouse_ray_cast() -> GridMap:
	mouse_position = get_viewport().get_mouse_position()
	ray_cast.target_position = camera.project_local_ray_normal(mouse_position) * 100.0
	ray_cast.force_raycast_update()
		
	if ray_cast.is_colliding():
		return ray_cast.get_collider()
	return null


#---------------------------------------------------------------------------------------------------#	

func _process(delta: float) -> void:
	#---Движение камеры
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * move_sensitivity * current_zoom.x 
		velocity.z = direction.z * move_sensitivity * current_zoom.x 
	else:
		velocity.x = move_toward(velocity.x, 0, move_sensitivity)
		velocity.z = move_toward(velocity.z, 0, move_sensitivity)

	if Input.is_action_pressed("top"):  
		velocity.y = move_sensitivity * current_zoom.x 
	elif Input.is_action_pressed("bottom") and camera.global_position.y > 1: 
		velocity.y = -move_sensitivity * current_zoom.x 
	else:
		velocity.y = move_toward(velocity.y, 0, move_sensitivity) 
		
	move_and_slide()

	
func _unhandled_input(event: InputEvent) -> void:
#---Выбор инструментов
	if Input.is_action_pressed('tool_1'):
		current_tool = 0
		tool_list_ui.select(0)
	if Input.is_action_pressed('tool_2'):
		current_tool = 1
		tool_list_ui.select(1)
	if Input.is_action_pressed('tool_3'):
		current_tool = 2
		tool_list_ui.select(2)
	if Input.is_action_pressed('tool_4'):
		current_tool = 3
		tool_list_ui.select(3)
		
	voxel_color = color_list_ui.get_selected_items()[0]
	current_tool = tool_list_ui.get_selected_items()[0]

#---Отмена и возврат
	if Input.is_action_pressed('undo', true):
		undo_redo.undo()
	if Input.is_action_pressed('redo', true):
		undo_redo.redo()
		
#---Вращение и центрирование камеры
	if Input.is_action_pressed('mouse_middle', true) and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		rotate_object_local(Vector3.LEFT, event.relative.y * sensitivity)
		
	if Input.is_action_pressed('mouse_middle') and Input.is_action_pressed('shift'):
		_camera_to_center()
		
#---Приблежение камеры
	if Input.is_action_just_released('wheel_down') and current_zoom < Vector3(50, 50, 50):
		current_zoom = get_scale() + Vector3(1, 1, 1) * sensitivity * 50
		scale = current_zoom
		
	if Input.is_action_just_released('wheel_up') and current_zoom > Vector3(1, 1, 1):
		current_zoom = get_scale() - Vector3(1, 1, 1) * sensitivity * 50
		scale = current_zoom
		
#---Управление освещением
	if Input.is_action_pressed('mouse_left') and Input.is_action_pressed('shift') and event is InputEventMouseMotion:
		update_sun_rotation(Input.get_last_mouse_velocity().x)
		
#---Функция для вставки одного вокселя
	if Input.is_action_just_pressed("mouse_left", true) and current_tool == 0:
		voxel_collider = _mouse_ray_cast()
		if voxel_collider != null:
			undo_redo.create_action("paste single voxel")
			undo_redo.add_do_method(voxel_collider.place_single_voxel.bind(ray_cast.get_collision_point() + ray_cast.get_collision_normal()/2, voxel_color))
			undo_redo.add_undo_method(voxel_collider.delete_single_voxel.bind(ray_cast.get_collision_point()))
			undo_redo.commit_action()
			#voxel_collider.place_single_voxel(ray_cast.get_collision_point() + ray_cast.get_collision_normal()/2, voxel_color)

#---Функция для рисования вокселей
	if Input.is_action_just_pressed("mouse_left", true) and current_tool == 1:
		mouse_position = get_viewport().get_mouse_position()
		ray_cast.target_position = camera.project_local_ray_normal(mouse_position) * 300.0
		ray_cast.force_raycast_update()
		voxel_height = (grid_map.local_to_map(ray_cast.get_collision_point() + ray_cast.get_collision_normal()/2)).y
	if Input.is_action_pressed("mouse_left") and current_tool == 1:
		voxel_collider = _mouse_ray_cast()
		if voxel_collider != null:
			voxel_collider.place_multiple_voxel(ray_cast.get_collision_point() + ray_cast.get_collision_normal()/2, voxel_color, voxel_height)
			
#---Функция для удаления одного вокселя
	if Input.is_action_just_pressed("mouse_right", true):
		voxel_collider = _mouse_ray_cast()
		var map_coordinate = grid_map.local_to_map(ray_cast.get_collision_point() - ray_cast.get_collision_normal())
		if voxel_collider != null and grid_map.get_cell_item(map_coordinate) != 10:
			undo_redo.create_action("delete multiple voxel")
			undo_redo.add_do_method(voxel_collider.delete_single_voxel.bind(ray_cast.get_collision_point() - ray_cast.get_collision_normal()/2))
			undo_redo.add_undo_method(voxel_collider.place_single_voxel.bind(ray_cast.get_collision_point() - ray_cast.get_collision_normal()/2, voxel_color))
			undo_redo.commit_action()
			#voxel_collider.delete_voxel(ray_cast.get_collision_point() - ray_cast.get_collision_normal())
		
#---Функция для стирания вокселей
	if Input.is_action_just_pressed("mouse_left", true) and current_tool == 2:
		mouse_position = get_viewport().get_mouse_position()
		ray_cast.target_position = camera.project_local_ray_normal(mouse_position) * 300.0
		ray_cast.force_raycast_update()
		voxel_height = (grid_map.local_to_map(ray_cast.get_collision_point() - ray_cast.get_collision_normal()/2)).y
	if Input.is_action_pressed("mouse_left") and current_tool == 2:
		voxel_collider = _mouse_ray_cast()
		if voxel_collider != null:
			voxel_collider.delete_multiple_voxel(ray_cast.get_collision_point() - ray_cast.get_collision_normal()/2, voxel_height)

#---Функция для смены цвета вокселей
	if Input.is_action_just_pressed("mouse_left", true) and current_tool == 3:
		voxel_collider = _mouse_ray_cast()
		var map_coordinate = grid_map.local_to_map(ray_cast.get_collision_point() - ray_cast.get_collision_normal())
		if voxel_collider != null and grid_map.get_cell_item(map_coordinate) != 10:
			undo_redo.create_action("repaint single voxel")
			undo_redo.add_do_method(voxel_collider.repaint_single_voxel.bind(ray_cast.get_collision_point() - ray_cast.get_collision_normal()/2, voxel_color))
			undo_redo.add_undo_method(voxel_collider.repaint_single_voxel.bind(ray_cast.get_collision_point() - ray_cast.get_collision_normal()/2, voxel_color))
			undo_redo.commit_action()
