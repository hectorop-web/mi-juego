extends CharacterBody2D
signal personajes_muerto
@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_2d: Area2D = $Area2D

var _vel_mov: float = 100.0
var _vel_jump: float = -300.0
var _muerto: bool

func _ready() -> void:
	add_to_group("personajes")
	area_2d.body_entered.connect(_tocar_pinchos)

func _physics_process(delta: float) -> void:
	if _muerto:
		return
	
	#Asignamos gravedad al personaje 
	velocity += get_gravity() * delta
	
	#Funcion de saltar para el personaje
	if Input.is_action_just_pressed("saltar") && is_on_floor():
		velocity.y = _vel_jump
	
	
	
	#Movimiento Lateral del personaje 
	if Input.is_action_pressed("der"):
		velocity.x = _vel_mov
		animacion.flip_h = true
	elif Input.is_action_pressed("izquierda"):
		velocity.x = -_vel_mov
		animacion.flip_h = false
	else:
		velocity.x = 0
	move_and_slide()
	
	#animacion del personaje
	if !is_on_floor():
		animacion.play("jump")
	elif velocity.x != 0:
		animacion.play("run")
	else:
		animacion.play("idle")

func _tocar_pinchos(_body: Node2D) -> void:
	animacion.modulate = Color(15.694, 0.003, 0.001, 1.0)
	_muerto = true
	animacion.stop()
	
	await get_tree().create_timer(0.5).timeout
	personajes_muerto.emit()
