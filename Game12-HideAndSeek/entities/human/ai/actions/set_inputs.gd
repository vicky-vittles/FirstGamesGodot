extends BehaviorTreeAction

export (Array, String) var buttons_to_press
export (Array, VirtualController.PRESS_TYPE) var press_types
export (Array, bool) var values

func _ready():
	assert(buttons_to_press.size() == press_types.size())
	assert(values.size() == press_types.size())

func tick(actor, blackboard):
	for i in buttons_to_press.size():
		var button = buttons_to_press[i]
		var press_type = press_types[i]
		var value = values[i]
		match press_type:
			VirtualController.PRESS_TYPE.PRESS:
				actor.input.set_press(button, value)
			VirtualController.PRESS_TYPE.HOLD:
				actor.input.set_hold(button, value)
			VirtualController.PRESS_TYPE.CONSUME:
				actor.input.set_consume(button, value)
