extends Node

# Uma máquina de estados padrão. Para usar, adicione ela à Node que fará uso dela,
# e dê um valor pra propriedade Actor Path (será a própria Node que você escolheu
# adicionar a StateMachine). A máquina de estados tem como nodes filhos vários estados
# possíveis para o Actor utilizar.
class_name StateMachine

export (NodePath) var actor_path #Caminho até a Node que fará uso da máquina
onready var actor = get_node(actor_path) #Instancia o Actor especificado pelo Actor Path
var current_state : Object #Estado atual

var is_active : bool = true #Se a máquina de estados está ativa ou não

func _ready():
	actor.connect("ready", self, "_on_Actor_ready")

func _on_Actor_ready():
	if is_active:
		current_state = get_child(0)
		current_state.enter()

func change_state(new_state):
	if is_active:
		current_state.exit()
		current_state = new_state
		
		current_state.enter()

func _process(delta):
	if is_active and current_state.has_method("process"):
		current_state.process(delta)

func _physics_process(delta):
	if is_active and current_state.has_method("physics_process"):
		current_state.physics_process(delta)

func disable():
	is_active = false
