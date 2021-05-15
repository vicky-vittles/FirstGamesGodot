extends Path

export (float) var speed

func path_by(current_dist: float):
	return curve.interpolate_baked(current_dist)
