extends Node

signal health_updated(actual_health)
signal has_died(hit)
signal defended_hit(hit, direction)

export (int) var max_health = 1
var actual_health = max_health
var is_alive = true

func _ready():
	for i in $"..".get_child_count():
		var child = $"..".get_child(i)
		
		if child != self and (child is AttackableHurtbox or child is StompableHurtbox):
			child.connect("hit_landed", self, "lose_health")
		elif child != self and (child is ProtectorHurtbox):
			child.connect("defended_hit", self, "defended_hit")

func lose_health(hit, direction):
	actual_health -= hit.damage
	emit_signal("health_updated", actual_health)
	
	if actual_health <= 0:
		is_alive = false
		emit_signal("has_died", hit, direction)

func defended_hit(hit, direction):
	emit_signal("defended_hit", hit, direction)
