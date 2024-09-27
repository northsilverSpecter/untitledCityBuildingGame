extends CharacterBody3D

#typical
const SPEED = 1000
const stopTheCap = SPEED #at least it's not diet coke

#not typical
var currents = {
	"x": 0,
	"z": 0
} #and you sir are not CURRENTLY a pog champ

#very cool
@onready var Cool = $collision

#speen speen
@onready var mateMeNot = $basic_cursor/AnimationPlayer

#peek peek
@onready var camera = $camera_anchor
@onready var model = $basic_cursor
const cam_spd = 2.5
const cam_spdMouse = cam_spd/256
var cam_vert = 0 #unused for now, this variable is now a stray cat

#zoom zoom
@onready var scroll = $camera_anchor/SpringArm3D/Camera3D/AudioStreamPlayer
const defaultZoomFunny = 1
const zoomCap = 5
const maxLevel = 20
const minLevel = 1
const defaultLevel = 10
const zoomTimer = 23
var zoomCurrent = 1
var levelCurrent = defaultLevel

#zoom zoom distances
const defaultDistance = 7
const maxCapDist = 9
const minCapDist = 5
@onready var distnceCurrent = $camera_anchor/SpringArm3D

#misc variables
var mouseActive = false
var kickInTheHead = true #Ain't that kick in the head? - Doctor from new vegas
var mustBeenTheWind = get_window()

var cam_vel = { #f*** that, velocity-based camera movement ain't worth it
		"hor": 0,
		"vert": 0,
		"max": cam_spd
	}

#let's roll with it
func _physics_process(delta: float) -> void:
	#camera (bwarp bwapr) (Aided by chatgpt)
	var based = camera.global_transform.basis
	var max_vert = deg_to_rad(25)
	var min_vert = -deg_to_rad(55)
	
	var cam_input = {
		"hor": Input.get_axis("RstickRight","RstickLeft"),
		"ver": Input.get_axis("RstickDown", "RstickUp")
	}
	var cam_dir = -Vector2(cam_input.hor,cam_input.ver)
	
	var movin = Input.get_last_mouse_velocity()
	var moves = -Vector2(movin.x * cam_spdMouse, movin.y * cam_spdMouse)

	#rock-a-bye billy, please don't you cry ;(
	if NOTIFICATION_APPLICATION_FOCUS_IN and Input.is_action_just_pressed("mousePeeker") and NOTIFICATION_VP_MOUSE_ENTER:
		mouseActive = true
		print("Me is active")
	elif NOTIFICATION_APPLICATION_FOCUS_OUT and NOTIFICATION_VP_MOUSE_EXIT:
		mouseActive = false
		print("I don't exist")
	
	if cam_dir: #for proof, there's no cam_vel, it's just normal camera movement
		#vroom vroom
		camera.rotation.y += (cam_dir.x * cam_spd) * delta

		#scrollin
		if not Input.is_action_pressed("zoomButton"):
			cam_vert += (cam_dir.y * cam_spd) * delta
		else:
			if (zoomCurrent < zoomCap):
				zoomCurrent += zoomTimer * delta
			elif (levelCurrent < maxLevel) or (levelCurrent > minLevel):
				zoomCurrent = defaultZoomFunny
				if (-cam_dir.y):
					levelCurrent += 1
				else:
					levelCurrent -= 1
				cam_vert = cam_vert + ((cam_dir.y * cam_spd) * delta)*3
				scroll.play()



	elif moves and mouseActive: #holding the rodent, the uhhhh.... gooober
		#360 no scope
		camera.rotation.y += moves.x * delta #wonky mouse control
		cam_vert += moves.y * delta
	else: #if no input of mouse or right stick
		camera.rotation.y = camera.rotation.y
		cam_vert = cam_vert

		if (!(Input.is_action_pressed("zoomButton")) or Input.is_action_pressed("zoomButton")) and !(cam_dir.y):
			zoomCurrent = defaultZoomFunny
	
	
	#skateboard vert 360 no scope- Combo Fail! Floor flop: -10000 social credits
	cam_vert = clamp(cam_vert,min_vert,max_vert)
	camera.rotation.x = cam_vert

	#--------------------------------------------------------------------------------	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir: Vector2 = Input.get_vector("LstickLeft","LstickRight","LstickUp","LstickDown")
	var direction: Vector3 = (based.x * input_dir.x + based.z * input_dir.y).normalized()
	

	if direction: #yup, no velocity-based movement as well (sigh)
		velocity.x = (direction.x * SPEED) * delta
		velocity.z = (direction.z * SPEED) * delta
	else:
		velocity.x = move_toward(direction.x, 0, SPEED)
		velocity.z = move_toward(direction.z, 0, SPEED)

	if not mateMeNot.is_playing():
		mateMeNot.play("speen")
	
	move_and_slide()
