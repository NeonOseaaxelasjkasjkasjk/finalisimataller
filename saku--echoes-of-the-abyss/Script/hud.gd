extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	

func show_game_over():
	show_message("Game over")
	await $MessageTimer.timeout
	$Message.text = "Dodge the\nCreeps"
	$Message.show()
	await get_tree().create_timer(1).timeout
	$StartButton.show()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()



func _on_message_timer_timeout() -> void:
	$Message.hide()
