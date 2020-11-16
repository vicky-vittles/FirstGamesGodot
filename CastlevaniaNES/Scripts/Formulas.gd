extends Node

static func calculate_gravity(height, time):
	var result = 2 * height / (time * time)
	return result

static func calculate_speed(height, time):
	return -2 * height / time
