extends Node

func linear(a, b, t):
	return lerp(a, b, t)

func easeInSine(a, b, t):
	var y = 1 - cos(t*PI/2)
	return linear(a, b, y)

func easeInCirc(a, b, t):
	var y = 1 - sqrt(1 - t*t);
	return linear(a, b, y)

func curve(curve, a, b, t):
	var y = curve.interpolate(t)
	return linear(a, b, y)
