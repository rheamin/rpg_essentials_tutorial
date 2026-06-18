extends CharacterBody2D

enum State {
	IDLE,
	RUN,
	ATTACK,
	DEAD
}

@export_category("Stats")
@export var speed: int = 400

var state: State = State.IDLE
var move_dir: Vector2 = Vector2.ZERO

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]


func _physics_process(delta: float) -> void:
	movement_loop()


func movement_loop() -> void:
	# get move directions
	move_dir.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	move_dir.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

	# set movement
	var motion: Vector2 = move_dir.normalized() * speed
	set_velocity(motion)
	move_and_slide()
	
	# flip sprite
	if state == State.IDLE or state == State.RUN:
		if move_dir.x < -0.01:
			$Sprite2D.flip_h = true
		elif move_dir.x > 0.01:
			$Sprite2D.flip_h = false

	if motion != Vector2.ZERO and state == State.IDLE:
		state = State.RUN
		update_animation()
	elif motion == Vector2.ZERO and state == State.RUN:
		state = State.IDLE
		update_animation()


	
func update_animation() -> void: 
	match state:
		State.IDLE:
			animation_playback.travel("idle")
		State.RUN:
			animation_playback.travel("run")
		State.ATTACK:
			animation_playback.travel("attack")
