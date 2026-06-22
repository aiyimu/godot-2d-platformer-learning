extends CharacterBody2D

# 移动参数
@export var speed: float = 300.0
@export var acceleration: float = 1500.0
@export var friction: float = 1200.0

# 跳跃参数
@export var jump_velocity: float = -400.0
@export var jump_cut_multiplier: float = 0.4
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1

# 重力
@export var gravity: float = 980.0

# 内部变量
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var was_on_floor: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# 重力
	if not is_on_floor():
		velocity.y += gravity * delta

	# 土狼时间
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# 跳跃缓冲
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	# 跳跃执行
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	# 可变高度跳跃（松开跳跃键时削减上升速度）
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= jump_cut_multiplier

	# 水平移动
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

	# 角色朝向
	if direction != 0.0:
		scale.x = direction

	# 记录上一帧是否在地面
	was_on_floor = is_on_floor()

	move_and_slide()

	# 更新动画
	_update_animation()

func _update_animation() -> void:
	if not is_on_floor():
		if velocity.y < 0.0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
	else:
		if abs(velocity.x) > 1.0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
