extends CharacterBody3D

var speed = 9.0
var sensitivity = 0.005
var zoom_speed = 0.1
var current_zoom = Vector3(1, 1, 1)


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
		
	if Input.is_action_pressed('mouse_middle') and not Input.is_action_pressed('shift') and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		rotate_object_local(Vector3.LEFT, event.relative.y * sensitivity)
		
	if Input.is_action_just_released('wheel_down') and current_zoom < Vector3(50, 50, 50):
		current_zoom = get_scale() + Vector3(1, 1, 1) * sensitivity * 50
		scale = current_zoom
		
	if Input.is_action_just_released('wheel_up') and current_zoom > Vector3(1, 1, 1):
		current_zoom = get_scale() - Vector3(1, 1, 1) * sensitivity * 50
		scale = current_zoom
		
