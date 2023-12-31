extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var movement_enabled : bool = true

var anim_sprite : AnimatedSprite2D

func _ready():
	anim_sprite = get_node_or_null("AnimSprite")
	anim_sprite.play("default")
	pass
	

func movement(enable):
	movement_enabled = enable
	
func _physics_process(delta):
	
	if abs(velocity.x) > 0:
		anim_sprite.play("walking")
	else:
		anim_sprite.play("default")
		
		
	var jumped = Input.is_action_just_pressed("ui_accept") and is_on_floor()

	var direction = Input.get_axis("Left", "Right")

	if !movement_enabled:
		direction = 0
		jumped = false
#		return
	
	if jumped:
		velocity.y = JUMP_VELOCITY

	if not is_on_floor():
		velocity.y += gravity * delta
		
	if direction:
		velocity.x = direction * SPEED
		anim_sprite.flip_h = false if direction > 0 else true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

	move_and_slide()

