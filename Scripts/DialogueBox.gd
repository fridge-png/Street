extends Control

@export var label : Label

var writing : bool = false
var pressed : bool = false
var active : bool = false

func _ready():
	self.visible = false
	pass

func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		pressed = true
	
	pass
	
	
func writeSentence(sentence : String):
	var text = ""
	var ind = 0
	writing = true
	while label.text != sentence:
		text += sentence[ind]
		label.text = text
		ind += 1
		await get_tree().create_timer(0.05).timeout
	writing = false
	
func showText(sentences : Array):
	self.visible = true
	active = true

	for sentence in sentences:
		writeSentence(sentence)
		await wait_till_press_any()
		
		if writing:
			label.text = sentence
			await wait_till_press_any()
	active = false
	self.visible = false
	
	
		
func wait_till_press_any():
	pressed = false
	while pressed != true:
		await get_tree().create_timer(0.2).timeout
	

func is_active():
	return active

#func _input(event):
#	if event is InputEventKey:
#		if event.pressed event.is:
#			pressed = true
