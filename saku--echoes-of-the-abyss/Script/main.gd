extends Node

@export var mob_scene: PackedScene

func _ready():
	pass

func game_over():
	$HUD.show_game_over()

func new_game():
	$saku.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("¡Empieza el juego!")

func _on_start_timer_timeout():
	$ModTimer.start()

func _on_mod_timer_timeout():
	if mob_scene == null:
		print("Error: 'mob_scene' no está asignado.")
		return

	# Instanciar el mob desde la escena
	var mob = mob_scene.instantiate()

	
	var path_follow = get_node("Path2D/PathFollow2D")
	if path_follow == null:
		print("Error: No se encontró 'PathFollow2D' en el mob.")
		return

	# Asignar un progreso aleatorio en la curva
	path_follow.progress_ratio = randf()

	# Agregar el mob a la escena
	var direction = path_follow.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	
	mob.rotation = direction
	mob.position = path_follow.position
	
	add_child(mob)
