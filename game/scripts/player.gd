extends KinematicBody2D

var MAX_SPEED = 256
var ACCELERATION = 2000
var motion = Vector2()


func _physics_process(delta):
	var axis = get_input_axis()
	set_animation(axis)
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)


func get_input_axis():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()


func set_animation(axis):
	if axis == Vector2.ZERO:
		$AnimationPlayer.stop()
		$Sprite.frame_coords = Vector2($Sprite.frame_coords.x, 0)
	if axis == Vector2(0, -1):
		$AnimationPlayer.play("Up")
	if axis == Vector2(0, 1):
		$AnimationPlayer.play("Down")
	if axis == Vector2(-1, 0):
		$AnimationPlayer.play("Left")
	if axis == Vector2(1, 0):
		$AnimationPlayer.play("Right")


func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO


func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)
