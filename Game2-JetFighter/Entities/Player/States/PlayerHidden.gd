extends State

var player

func enter():
	player = fsm.actor

func exit():
	#Quando houver a transição para um novo estado, este método do estado antigo é chamado;
	pass

func process(delta):
	#Método _process do estado. Chamado pela máquina de estados.
	pass

func physics_process(delta):
	#Método _physics_process do estado. Chamado pela máquina de estados.
	pass
