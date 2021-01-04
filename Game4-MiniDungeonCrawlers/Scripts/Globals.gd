extends Node

static func sort_by_health(a, b):
	if a.health.health < b.health.health:
		return true
	return false

static func sort_by_distance(a, b):
	if a[1] < b[1]:
		return true
	return false
