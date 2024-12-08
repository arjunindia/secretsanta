extends CharacterBody2D


const ACC = 30.0
const FRICTION = 80
const WALK_SPEED = 50
const RUN_SPEED = 80

var max_speed = 50
var motion := Vector2();

var is_running = null
var last_direction="down"

func _physics_process(delta: float) -> void:
	var input = Vector2()
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input = input.normalized()
	
	if Input.is_action_pressed("run"):
		is_running = true
	if Input.is_action_just_released("run"):
		is_running = false
	
	if input!=Vector2.ZERO: # check if idle
		# Choose which animation to play on input
		var status = "run" if is_running else "walk"
		var x_direction = "right" if input.x>0 else "left"
		var y_direction = "down" if input.y>0 else "up"
		var direction = x_direction if input.x!=0 else y_direction
		var sprite = status+"_"+direction
		$AnimatedSprite2D.play(sprite)
		last_direction=direction # We save the last direction the player was to keep it when input is gone
		# movement
		if is_running:
			max_speed=RUN_SPEED
		else:
			max_speed=WALK_SPEED
		motion+=input*ACC*delta
		motion=motion.limit_length(max_speed*delta);
	else:
		# idle
		$AnimatedSprite2D.play("idle_"+last_direction)
		motion=motion.move_toward(Vector2.ZERO,FRICTION*delta)

	move_and_collide(motion)
