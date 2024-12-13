extends CharacterBody2D

@export var move_speed: float
@export var jump_speed: float
@onready var animated_sprite = $AnimatedSprite2D
@onready var atacar_area: Area2D = $Area2D

var is_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var atacar:bool = false
var atacar_timer = 0.0
var atacar_duracion: float = 0.5

var can_doble_jump = true
var has_doble_jump = true

@warning_ignore("shadowed_variable_base_class")
func start(position: Vector2):
	self.position = position  # Coloca al personaje en la posición inicial
	velocity = Vector2.ZERO  # Reinicia cualquier movimiento



func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor():
		can_doble_jump = true
		has_doble_jump = true
		
	if Input.is_action_just_pressed("atacar") and not atacar:
		atacar = true
		atacar_timer = 0.0
		animated_sprite.play("atacar")
		atacar_play()
	
	if !atacar:
		jump(delta)
		move_x()
		flip()
	
	else:
		atacar_timer += delta
		if atacar_timer >= atacar_duracion:
			atacar = false
	 
	move_and_slide()
	update_animations()

func update_animations():
	if atacar:
		return
	
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("saltar")
		else:
			animated_sprite.play("caer")
		return
	
	if velocity.x != 0: 
		animated_sprite.play("correr")
	else:
		animated_sprite.play("reposo")


func jump(_delta):
	if not atacar:
		
		if Input.is_action_just_pressed("saltar") and is_on_floor():
			velocity.y = -jump_speed
		
		elif Input.is_action_just_pressed("saltar") and can_doble_jump and not is_on_floor():
			if not has_doble_jump:
				velocity.y = -jump_speed
				has_doble_jump = true
				can_doble_jump = false


func flip():
	if not atacar:
		if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
			scale.x *= -1
			is_facing_right = not is_facing_right
	

func move_x():
	if not atacar:
		var input_axis = Input.get_axis("izquierda","derecha")
		velocity.x = input_axis * move_speed
		

func atacar_play():
	for body in atacar_area.get_overlapping_bodies():
		if body is CharacterBody2D and body.has_method("take_damage"):
			body.take_damage(10) # Infligir daño al enemigo
