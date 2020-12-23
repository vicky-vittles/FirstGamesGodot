extends Node

# Um estado para ser utilizado com a máquina de estados. Deve ser estendido e ter
# seus métodos implementados, e depois instanciado e adicionado como child da máquina.
class_name State

export (NodePath) var fsm_path #Caminho até a Node pai (máquina de estados)
onready var fsm = get_node(fsm_path) #Pegar referência à máquina de estados usando Fsm Path

func enter():
	#Quando houver a transição pra um novo estado, este método do estado novo é chamado
	pass

func exit():
	#Quando houver a transição para um novo estado, este método do estado antigo é chamado;
	pass

func process(_delta):
	#Método _process do estado. Chamado pela máquina de estados.
	pass

func physics_process(_delta):
	#Método _physics_process do estado. Chamado pela máquina de estados.
	pass
