extends CharacterBody2D

@export var speed: float = 100.0  # Velocidad de movimiento
@export var points: int = 10  # Puntos que otorga al ser eliminado
@export var vida: int = 50  # Vida inicial del mob

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var path_follow: PathFollow2D = get_node("/root/Main/PathFollow2D")

var progreso: float = 0.0
var direccion: bool = true
var gravity_scale: float

func _ready():
	# Configuración inicial
	gravity_scale = 0  # Desactivar la gravedad
	
	# Asegurarse de que la animación de caminar está activa
	if sprite:
		sprite.play("volar")
	
	# Log de inicio
	print("Mob iniciado en posición: ", position)

func _physics_process(delta: float):
	if vida > 0:
		mover(delta)
	
	# Verificación de límites más flexible
	verificar_limites(480, 270)

func mover(delta):
	if path_follow and vida > 0:
		# Incrementar el progreso en el camino
		path_follow.progress_ratio += (speed * delta) / 100.0
		
		# Actualizar posición basada en el path follow
		position = path_follow.global_position
		
		# Actualizar variable de progreso
		progreso = path_follow.progress_ratio

func verificar_limites(map_width: int, map_height: int):
	# Obtener los límites de la pantalla o del mapa
	var viewport_rect = Rect2(Vector2.ZERO, Vector2(map_width, map_height))
	
	if (position.x < viewport_rect.position.x or 
		position.x > viewport_rect.end.x or
		position.y < viewport_rect.position.y or 
		position.y > viewport_rect.end.y):
		print("Eliminado por estar fuera de los límites: ", position)
		destruir()

func recibir_dano(dano: int):
	if vida >= dano:
		vida -= dano
		# Restar el daño de la vida actual
		if vida <= 0:
			destruir()

func destruir():
	print("Eliminado, sumando", points, "puntos.")
	queue_free()  # Eliminar el mob
