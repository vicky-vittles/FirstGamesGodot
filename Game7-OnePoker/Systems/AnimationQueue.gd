extends Node

var queue = []


# Enqueues an animation node (Tween or AnimationPlayer) to be played when possible
# Dictionary: "anim_node" and "anim_name"
func enqueue_animation(anim_node, anim_name : String = "") -> void:
	var was_empty = queue.size() == 0
	var anim = {"anim_node":anim_node, "anim_name":anim_name}
	queue.append(anim)
	if anim_node is Tween:
		anim_node.connect("tween_completed", self, "_on_Queue_Tween_finished")
	elif anim_node is AnimationPlayer:
		anim_node.connect("animation_finished", self, "_on_Queue_AnimationPlayer_finished")
	if was_empty:
		play_animation(anim)


# Called when an animation finished. Immediately plays the next one in the queue,
# if it exists
func animation_finished() -> void:
	var _prev_anim = queue.pop_front()
	var next_anim = queue.front()
	if next_anim:
		play_animation(next_anim)


# Play animation (receives anim)
func play_animation(anim):
	var anim_node = anim["anim_node"]
	var anim_name = anim["anim_name"]
	if anim_node is Tween:
		anim_node.start()
	elif anim_node is AnimationPlayer:
		anim_node.play(anim_name)


func _on_Queue_Tween_finished(_object, _node_path):
	animation_finished()

func _on_Queue_AnimationPlayer_finished(_name):
	animation_finished()
