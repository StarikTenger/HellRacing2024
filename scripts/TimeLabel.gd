extends Label

var time_elapsed := 0.0

func _process(delta):
	time_elapsed += delta
	text = "Время: %d:%02d" % [floor(time_elapsed / 60), int(time_elapsed) % 60]
