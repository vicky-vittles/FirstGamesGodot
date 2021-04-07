extends Node2D

enum CAR_COLOR {
	BLACK = 0,
	BLUE = 5,
	GREEN = 10,
	RED = 15,
	YELLOW = 20}
enum CAR_TYPE {
	SLICK = 0,
	SMALL = 1,
	RACER = 2,
	HEAVY = 3,
	COMPACT = 4}

export (CAR_COLOR) var car_color = CAR_COLOR.RED
export (CAR_TYPE) var car_type = CAR_TYPE.SLICK

onready var car_sprite = $CarSprite

func _ready():
	set_car_sprite()

func set_car_sprite():
	car_sprite.frame = car_color + car_type

func set_car_attributes(_col, _type):
	car_color = _col
	car_type = _type
	set_car_sprite()
