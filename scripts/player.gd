extends CharacterBody3D

const SPEED = 1000

@onready var Cool = $collision
@onready var mateMeNot = $basic_cursor/AnimationPlayer
@onready var camera = $camera_anchor
@onready var model = $basic_cursor
@onready var zom_camera = $camera_anchor/cam
@onready var scroll = $camera_anchor/cam/scroll
@onready var timer = $zoomTimer

const cam_spd = 2.5
const zom_spd = 20
const zom_min = -2.5
const zom_max = 8.5
var cam_spdMouse = cam_spd/256
var cam_vert = 25

var mouseActive = false

var cam_dir = Vector2((Input.get_axis("RstickRight","RstickLeft")) * cam_spd, (Input.get_axis("RstickDown", "RstickUp")) * cam_spd)
var moves = -Vector2(Input.get_last_mouse_velocity().x * cam_spdMouse, Input.get_last_mouse_velocity().y * cam_spdMouse)
var zoomWithin = Input.is_action_pressed("zoomButton")

func _physics_process(delta: float) -> void:
	var based = camera.global_transform.basis
	var input_dir: Vector2 = Input.get_vector("LstickLeft","LstickRight","LstickUp","LstickDown")
	var direction: Vector3 = ((based.x * input_dir.x + based.z * input_dir.y).normalized())

	cam_dir = Vector2((Input.get_axis("RstickRight","RstickLeft")), (Input.get_axis("RstickDown", "RstickUp")))
	moves = -Vector2(Input.get_last_mouse_velocity().x * cam_spdMouse, Input.get_last_mouse_velocity().y * cam_spdMouse)
	zoomWithin = Input.is_action_pressed("zoomButton")

	if not zoomWithin:
		cam_movement(delta)
	else:
		zoomAdjust(delta)
	
	cam_vert = clamp(cam_vert,24.5,25.5) #why create deg_to_rad variables when you can just type it in?
	camera.rotation.x = cam_vert

	if direction:
		velocity.x = (direction.x * SPEED) * delta
		velocity.z = (direction.z * SPEED) * delta
	else:
		velocity.x = move_toward(direction.x, 0, SPEED)
		velocity.z = move_toward(direction.z, 0, SPEED)

	if not mateMeNot.is_playing():
		mateMeNot.play("speen")

	move_and_slide()

func cam_movement(delta: float):
	if cam_dir:
		camera.rotation.y += (cam_dir.x * cam_spd) * delta
		cam_vert += (cam_dir.y * cam_spd) * delta 
	elif moves:
		camera.rotation.y += moves.x * delta
		cam_vert += moves.y * delta
	else:
		camera.rotation.y = camera.rotation.y
		cam_vert = cam_vert
	return cam_vert

func zoomAdjust(delta: float):
	if (timer.is_stopped()):
		timer.start(0.015)
		zoomActive(delta)
				
func zoomActive(delta: float):
	if (zom_camera.position.z > zom_min) or (zom_camera.position.z < zom_max):
			zom_camera.position.z += (-cam_dir.y * (zom_spd * cam_spd)) * delta
	
	#I was suppose to add a mouse scroll or brackets key zoom based on roblox 2006 but
	#that isn't the case now, the axis must be the issue since those inputs are not based
	#on the Vector2/Vector3 sort of input. I rather not waste my keyboard typings on this :(

	#btw, I like the jittery feel of it so shut up if you want smooth zooming

	if (zom_camera.position.z > zom_max):
		zom_camera.position.z = zom_max
		scroll.stop()
	elif (zom_camera.position.z < zom_min):
		zom_camera.position.z = zom_min
		scroll.stop()
	elif cam_dir:
		scroll.play()
	
	print(zom_camera.position.z)