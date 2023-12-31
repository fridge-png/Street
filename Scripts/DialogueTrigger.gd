extends Node2D

var dialogue_box : Control
var player : CharacterBody2D
var dtso : DTSO

var moving_player : bool = false

var current_sentence : int = 0

@export var collision_shape : CollisionShape2D
@export var anim_sprite : AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	dtso = get_meta("dtso")
	
	dialogue_box = get_node_or_null("/root/Scene/CanvasLayer/DialogueBox")
	player = get_node_or_null("/root/Scene/Player")
	
	collision_shape.shape.size = dtso.collision_size
	anim_sprite.sprite_frames = dtso.sprite_frames
	anim_sprite.play("default")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var distance_from_player = player.position.x - self.position.x
	var direction = -1 if distance_from_player < 0 else 1 
	if moving_player:
		if abs(abs(distance_from_player) - dtso.collision_size.x/2) > 100:
			moving_player = false
			player.velocity.x = 0
			player.movement(true)
			return
		player.velocity.x = direction * player.SPEED
		player.move_and_slide()
	pass

func _on_area_2d_body_entered(body):
	if !dialogue_box.call("is_active"):
		player.movement(false)
		anim_sprite.play("talking")
		await dialogue_box.call("showText",dtso.sentences[current_sentence])
		anim_sprite.play("default")
		current_sentence = int(fmod(current_sentence + 1 , dtso.sentences.size()))
		moving_player = true
		
	pass

	
func _on_area_2d_body_exited(body):
	pass # Replace with function body.
