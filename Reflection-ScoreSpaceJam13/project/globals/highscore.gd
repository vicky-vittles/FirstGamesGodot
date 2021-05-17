extends Node

const HIGHSCORES_FILE_PATH = "user://highscores.save"

func write(content):
	var file = File.new()
	file.open(HIGHSCORES_FILE_PATH, File.WRITE)
	file.store_var(content)
	file.close()

func read():
	var file = File.new()
	if not file.file_exists(HIGHSCORES_FILE_PATH):
		write(0)
	file.open(HIGHSCORES_FILE_PATH, File.READ)
	var content = file.get_var()
	file.close()
	return content
